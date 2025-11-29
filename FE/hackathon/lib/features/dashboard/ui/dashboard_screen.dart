import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/waveform_visualizer.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/services/audio_recording_service.dart';
import '../../../shared/services/sound_detection_service.dart';
import '../../../shared/services/notification_service.dart';
import '../../../data/datasources/remote/sound_detection_api_client.dart';
import '../../../shared/widgets/waveform_painter.dart';

/// Dashboard Screen
/// Main monitoring screen with audio visualization and recording
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final AudioRecordingService _audioService;
  late final SoundDetectionApiClient _apiClient;
  late final NotificationService _notificationService;
  late final SoundDetectionService _detectionService;

  bool _isRecording = false;
  bool _isInitialized = false;
  String _statusText = 'Ready';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _audioService = AudioRecordingService();
      _apiClient = SoundDetectionApiClient();
      _notificationService = NotificationService();

      await _audioService.initialize();
      await _notificationService.initialize();

      _detectionService = SoundDetectionService(
        audioService: _audioService,
        apiClient: _apiClient,
        notificationService: _notificationService,
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing services: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to initialize: $e')));
      }
    }
  }

  Future<void> _toggleRecording() async {
    if (!_isInitialized) return;

    try {
      if (_isRecording) {
        // Stop recording
        await _detectionService.stop();
        setState(() {
          _isRecording = false;
          _statusText = 'Stopped';
        });
      } else {
        // Start recording
        await _detectionService.start();
        setState(() {
          _isRecording = true;
          _statusText = 'Monitoring...';
        });
      }
    } catch (e) {
      debugPrint('Error toggling recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _buildSimpleWaveform() {
    return StreamBuilder<double>(
      stream: _audioService.amplitudeStream,
      builder: (context, snapshot) {
        final amplitude = snapshot.data ?? 0.0;
        // Normalize amplitude to 0-1 for visualization
        final normalized = (amplitude / 100.0).clamp(0.0, 1.0);

        return CustomPaint(
          size: const Size(double.infinity, 107.25),
          painter: WaveformPainter(amplitude: normalized),
        );
      },
    );
  }

  @override
  void dispose() {
    _detectionService.dispose();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: App Icon, Title, Status
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppTheme.appIconGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guardian',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 4),
                          StatusBadge(
                            dotColor: _isRecording
                                ? AppTheme.statusGreen
                                : AppTheme.textTertiary,
                            text: _statusText,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Right: Settings Button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.statusGreenLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Navigate to settings
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: AppTheme.statusGreenText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Waveform Visualizer (simplified - using placeholder)
              WaveformVisualizer(
                isLive: _isRecording,
                waveformContent: _isRecording ? _buildSimpleWaveform() : null,
              ),
              const SizedBox(height: 24),
              // Recording Control Button
              if (_isInitialized)
                PrimaryButton(
                  text: _isRecording ? 'Stop Recording' : 'Start Recording',
                  onPressed: _toggleRecording,
                )
              else
                const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
