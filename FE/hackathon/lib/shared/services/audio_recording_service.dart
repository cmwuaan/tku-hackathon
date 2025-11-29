import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Audio Recording Service
/// Handles continuous audio recording with threshold detection using MethodChannel
class AudioRecordingService {
  static const MethodChannel _channel = MethodChannel('com.hackathon/audio');

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

  /// Initialize the recorder
  Future<void> initialize() async {
    try {
      // Create recordings directory in system temp
      final tempDir = Directory.systemTemp;
      final recordingsPath = '${tempDir.path}/guardian_recordings';

      final dir = Directory(recordingsPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Request microphone permission
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        throw Exception('Microphone permission not granted');
      }

      _amplitudeStreamController = StreamController<double>.broadcast();
      _recordedFileStreamController = StreamController<String>.broadcast();
    } catch (e) {
      debugPrint('Error initializing audio recording service: $e');
      // Initialize controllers anyway - path will be handled when recording starts
      _amplitudeStreamController = StreamController<double>.broadcast();
      _recordedFileStreamController = StreamController<String>.broadcast();
    }
  }

  /// Request microphone permission
  Future<bool> _requestPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestPermission');
      return result ?? false;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      return false;
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

      // Start recording via native channel
      await _channel.invokeMethod('startRecording', {
        'path': _currentRecordingPath!,
      });

      _isRecording = true;
      _isPaused = false;
      _thresholdCrossedTime = null;

      // Start monitoring amplitude
      _startAmplitudeMonitoring();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      rethrow;
    }
  }

  /// Stop recording
  Future<void> stopRecording() async {
    if (!_isRecording) return;

    _stopAmplitudeMonitoring();
    try {
      await _channel.invokeMethod('stopRecording');
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
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
    try {
      await _channel.invokeMethod('stopRecording');
    } catch (e) {
      debugPrint('Error pausing recording: $e');
    }
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
            // Get current amplitude from native recorder
            final amplitude = await _channel.invokeMethod<double>(
              'getAmplitude',
            );
            final db = amplitude ?? 0.0;

            // Emit amplitude value
            _amplitudeStreamController?.add(db);

            // Check threshold (30dB)
            if (db >= _thresholdDb && _thresholdCrossedTime == null) {
              _thresholdCrossedTime = DateTime.now();
              debugPrint('Threshold crossed at ${db.toStringAsFixed(2)}dB');

              // Wait 5 seconds and capture audio
              _captureAudioClipAfterDelay();
            } else if (db < _thresholdDb) {
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
      try {
        await _channel.invokeMethod('stopRecording');
      } catch (e) {
        debugPrint('Error stopping recording for capture: $e');
      }
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
  }
}
