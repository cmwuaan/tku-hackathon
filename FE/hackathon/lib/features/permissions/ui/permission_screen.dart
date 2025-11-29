import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/progress_indicator.dart' as custom;
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/info_card.dart';
import '../../dashboard/ui/dashboard_screen.dart';

/// Permission Screen
/// Configurable permission screen for the setup flow
class PermissionScreen extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String permissionTitle;
  final String permissionDescription;
  final String infoDescription;
  final IconData icon;
  final VoidCallback? onAllow;
  final VoidCallback? onDeny;

  const PermissionScreen({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    required this.permissionTitle,
    required this.permissionDescription,
    required this.infoDescription,
    required this.icon,
    this.onAllow,
    this.onDeny,
  });

  void _handleAllow(BuildContext context) {
    if (onAllow != null) {
      onAllow!();
      return;
    }
    // Default navigation to next step
    if (currentStep < totalSteps) {
      final nextStep = currentStep + 1;
      if (nextStep == 2) {
        // Navigate to Step 2
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PermissionScreen(
              currentStep: 2,
              totalSteps: 3,
              permissionTitle: 'Monitor 24/7',
              permissionDescription:
                  'The app will monitor activities and important events at all times to protect you',
              infoDescription:
                  'This permission ensures you are protected at all times',
              icon: Icons.access_time,
            ),
          ),
        );
      } else if (nextStep == 3) {
        // Navigate to Step 3
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PermissionScreen(
              currentStep: 3,
              totalSteps: 3,
              permissionTitle: 'Display over lock screen',
              permissionDescription:
                  'Allow emergency alerts to be displayed even when the screen is locked or you are using other apps',
              infoDescription: 'Critical for timely alerts',
              icon: Icons.lock_outline,
            ),
          ),
        );
      }
    } else {
      // Last step - navigate to dashboard
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false, // Remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Progress Indicator
                    custom.StepProgressIndicator(
                      currentStep: currentStep,
                      totalSteps: totalSteps,
                      progress: progress,
                    ),
                    const SizedBox(height: 32),
                    // Large Icon
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        gradient: AppTheme.permissionIconGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 64, color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(height: 24),
                    // Permission Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundWhite,
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header
                          Row(
                            children: [
                              // App Icon
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.appIconGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // App Info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Guardian App',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF6A7282),
                                        ),
                                  ),
                                  Text(
                                    'Permission request',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            height: 1,
                            color: const Color(0xFFE5E7EB),
                          ),
                          // Permission Title
                          Text(
                            permissionTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          // Permission Description
                          Text(
                            permissionDescription,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(height: 1.625),
                          ),
                          const SizedBox(height: 18),
                          // Important Info Card
                          InfoCard(
                            icon: const Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Color(0xFFE17100),
                            ),
                            title: 'Important',
                            description: infoDescription,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Action Buttons (Fixed at bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Allow',
                    onPressed: () => _handleAllow(context),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(text: 'Deny', onPressed: onDeny),
                  const SizedBox(height: 16),
                  // Footer Text
                  Text(
                    'You can change this permission in Settings at any time',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
