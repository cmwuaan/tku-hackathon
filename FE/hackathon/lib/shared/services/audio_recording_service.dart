import 'dart:async';
import 'dart:io';
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';

/// Audio Recording Service
/// Handles continuous audio recording with threshold detection
class AudioRecordingService {
  final AudioRecorder _recorder = AudioRecorder();

  StreamController<double>? _amplitudeStreamController;
  StreamController<String>? _recordedFileStreamController;

  bool _isRecording = false;
  bool _isPaused = false;
  double _thresholdDb = 30.0; // Base threshold: 30dB

  Timer? _amplitudeTimer;
  String? _currentRecordingPath;
  DateTime? _thresholdCrossedTime;

  // 5 seconds buffer for audio capture
  static const Duration audioCaptureDuration = Duration(seconds: 5);

  /// Stream of amplitude values in dB
  Stream<double>? get amplitudeStream => _amplitudeStreamController?.stream;

  /// Stream of recorded file paths when threshold is crossed
  Stream<String>? get recordedFileStream =>
      _recordedFileStreamController?.stream;

  bool get isRecording => _isRecording;
  bool get isPaused => _isPaused;

  /// Initialize the recorder controller
  Future<void> initialize() async {
    try {
      // Create recordings directory in system temp (works without path_provider)
      final tempDir = Directory.systemTemp;
      final recordingsPath = '${tempDir.path}/guardian_recordings';

      final dir = Directory(recordingsPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Check if recorder has permission
      if (await _recorder.hasPermission()) {
        _amplitudeStreamController = StreamController<double>.broadcast();
        _recordedFileStreamController = StreamController<String>.broadcast();
      } else {
        throw Exception('Microphone permission not granted');
      }
    } catch (e) {
      debugPrint('Error initializing audio recording service: $e');
      // Initialize controllers anyway - path will be handled when recording starts
      _amplitudeStreamController = StreamController<double>.broadcast();
      _recordedFileStreamController = StreamController<String>.broadcast();
    }
  }

  /// Start recording
  Future<void> startRecording() async {
    if (_isRecording && !_isPaused) return;

    try {
      // Use system temp directory (works without path_provider)
      final tempDir = Directory.systemTemp;
      final recordingDir = '${tempDir.path}/guardian_recordings';

      // Ensure directory exists
      final dir = Directory(recordingDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '$recordingDir/recording_$timestamp.m4a';

      // Check permission before recording
      if (await _recorder.hasPermission()) {
        await _recorder.start(
          const RecordConfig(),
          path: _currentRecordingPath!,
        );

        _isRecording = true;
        _isPaused = false;
        _thresholdCrossedTime = null;

        // Start monitoring amplitude
        _startAmplitudeMonitoring();
      } else {
        throw Exception('Microphone permission not granted');
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
      rethrow;
    }
  }

  /// Stop recording
  Future<void> stopRecording() async {
    if (!_isRecording) return;

    _stopAmplitudeMonitoring();
    await _recorder.stop();
    _isRecording = false;
    _isPaused = false;
    _currentRecordingPath = null;
    _thresholdCrossedTime = null;
  }

  /// Pause recording (used when processing detected sound)
  Future<void> pauseRecording() async {
    if (!_isRecording || _isPaused) return;

    _isPaused = true;
    _stopAmplitudeMonitoring();
    await _recorder.stop();
  }

  /// Resume recording after processing
  Future<void> resumeRecording() async {
    if (!_isPaused || !_isRecording) return;

    _isPaused = false;
    await startRecording();
  }

  /// Start monitoring audio amplitude
  void _startAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();

    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) async {
      if (!_isRecording || _isPaused) {
        timer.cancel();
        return;
      }

      try {
        if (_isRecording && !_isPaused) {
          try {
            // Get current amplitude from recorder
            final amplitude = await _recorder.getAmplitude();

            // Convert amplitude to dB
            // Amplitude.current is typically -160 to 0 dB
            final db = amplitude.current > -160 ? amplitude.current : -80.0;

            // Emit amplitude value (convert to positive scale for display)
            final displayDb =
                db + 160; // Convert to 0-160 scale, then normalize
            _amplitudeStreamController?.add(displayDb);

            // Check threshold (30dB on the normalized scale)
            if (displayDb >= _thresholdDb && _thresholdCrossedTime == null) {
              _thresholdCrossedTime = DateTime.now();
              debugPrint(
                'Threshold crossed at ${displayDb.toStringAsFixed(2)}dB',
              );

              // Wait 5 seconds and capture audio
              _captureAudioClipAfterDelay();
            } else if (displayDb < _thresholdDb) {
              // Reset threshold crossing if level drops below threshold
              _thresholdCrossedTime = null;
            }
          } catch (e) {
            debugPrint('Error in amplitude monitoring: $e');
          }
        }
      } catch (e) {
        debugPrint('Error monitoring amplitude: $e');
      }
    });
  }

  /// Capture audio clip after 5 seconds delay
  void _captureAudioClipAfterDelay() {
    Future.delayed(audioCaptureDuration, () async {
      await _captureAudioClip();
    });
  }

  /// Stop monitoring amplitude
  void _stopAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
  }

  /// Capture 5 seconds of audio when threshold is crossed
  Future<void> _captureAudioClip() async {
    if (_currentRecordingPath == null || !_isRecording) return;

    try {
      // Stop current recording
      final capturedPath = _currentRecordingPath;
      await _recorder.stop();
      _isRecording = false;

      // Wait for the file to be finalized
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if file exists
      final file = File(capturedPath!);
      if (await file.exists()) {
        final fileSize = await file.length();
        if (fileSize > 0) {
          // Emit the recorded file path
          _recordedFileStreamController?.add(capturedPath);
          debugPrint(
            'Audio clip captured: $capturedPath (size: $fileSize bytes)',
          );
        }
      }

      // Reset for next recording
      _currentRecordingPath = null;
      _thresholdCrossedTime = null;
    } catch (e) {
      debugPrint('Error capturing audio clip: $e');
    }
  }

  /// Set threshold in dB
  void setThreshold(double db) {
    _thresholdDb = db;
  }

  /// Dispose resources
  void dispose() {
    _stopAmplitudeMonitoring();
    _amplitudeStreamController?.close();
    _recordedFileStreamController?.close();
    _recorder.dispose();
  }
}
