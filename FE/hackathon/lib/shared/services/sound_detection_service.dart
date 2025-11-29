import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'audio_recording_service.dart';
import '../../data/datasources/remote/sound_detection_api_client.dart';
import 'notification_service.dart';

/// Sound Detection Service
/// Orchestrates audio recording, threshold detection, API calls, and notifications
class SoundDetectionService {
  final AudioRecordingService _audioService;
  final SoundDetectionApiClient _apiClient;
  final NotificationService _notificationService;

  StreamSubscription<String>? _recordedFileSubscription;
  bool _isProcessing = false;

  SoundDetectionService({
    required AudioRecordingService audioService,
    required SoundDetectionApiClient apiClient,
    required NotificationService notificationService,
  }) : _audioService = audioService,
       _apiClient = apiClient,
       _notificationService = notificationService {
    _setupListeners();
  }

  /// Set up listeners for recorded audio files
  void _setupListeners() {
    _recordedFileSubscription?.cancel();

    _recordedFileSubscription = _audioService.recordedFileStream?.listen(
      (filePath) async {
        if (!_isProcessing) {
          await _processDetectedSound(filePath);
        }
      },
      onError: (error) {
        debugPrint('Error in recorded file stream: $error');
      },
    );
  }

  /// Process detected sound: send to API and handle response
  Future<void> _processDetectedSound(String filePath) async {
    if (_isProcessing) return;

    _isProcessing = true;

    try {
      debugPrint('Processing detected sound: $filePath');

      // Send audio file to API
      final response = await _apiClient.detectSound(File(filePath));

      if (response.success && response.data != null) {
        final data = response.data!;
        debugPrint(
          'Detection result: ${data.topLabel} (confidence: ${data.value})',
        );

        // Show notification with result
        await _notificationService.showDangerAlert(
          title: 'Sound Detected',
          body:
              '${data.topLabel} detected (${(data.value * 100).toStringAsFixed(1)}% confidence)',
          context: null, // Will be set from UI if needed
        );

        // Success - resume recording automatically
        if (_audioService.isPaused) {
          await _audioService.resumeRecording();
        } else if (!_audioService.isRecording) {
          await _audioService.startRecording();
        }
      } else {
        debugPrint('Detection failed: ${response.message}');
        // Still resume recording even if detection failed
        if (_audioService.isPaused) {
          await _audioService.resumeRecording();
        } else if (!_audioService.isRecording) {
          await _audioService.startRecording();
        }
      }
    } catch (e) {
      debugPrint('Error processing detected sound: $e');

      // Show error notification
      await _notificationService.showWarningAlert(
        title: 'Detection Error',
        body: 'Failed to process audio: ${e.toString()}',
        context: null,
      );

      // Resume recording on error
      if (_audioService.isPaused) {
        await _audioService.resumeRecording();
      } else if (!_audioService.isRecording) {
        await _audioService.startRecording();
      }
    } finally {
      _isProcessing = false;
    }
  }

  /// Start sound detection service
  Future<void> start() async {
    await _audioService.startRecording();
  }

  /// Stop sound detection service
  Future<void> stop() async {
    await _audioService.stopRecording();
    _isProcessing = false;
  }

  /// Pause detection (for when processing)
  Future<void> pause() async {
    await _audioService.pauseRecording();
  }

  /// Resume detection
  Future<void> resume() async {
    await _audioService.resumeRecording();
  }

  /// Get audio recording service (for waveform visualization)
  AudioRecordingService get audioService => _audioService;

  /// Dispose resources
  void dispose() {
    _recordedFileSubscription?.cancel();
    _audioService.dispose();
  }
}
