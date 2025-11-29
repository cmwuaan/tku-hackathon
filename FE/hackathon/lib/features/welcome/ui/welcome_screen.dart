import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/feature_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../permissions/ui/permission_screen.dart';

/// Welcome Screen
/// First screen shown to users introducing the app features
class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onStartSetup;

  const WelcomeScreen({super.key, this.onStartSetup});

  void _handleStartSetup(BuildContext context) {
    if (onStartSetup != null) {
      onStartSetup!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PermissionScreen(
            currentStep: 1,
            totalSteps: 3,
            permissionTitle: 'Run in background',
            permissionDescription:
                'Allow the app to continue running when you close the screen or switch to other apps',
            infoDescription: 'Required for continuous protection',
            icon: Icons.settings_backup_restore,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 24),
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // App Icon/Logo
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        gradient: AppTheme.appIconGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // App Title
                    Text(
                      'Guardian App',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      'Comprehensive protection and monitoring for your device',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    // Feature Cards
                    Column(
                      children: [
                        FeatureCard(
                          backgroundColor: AppTheme.featureCard1Bg,
                          iconBackgroundColor: AppTheme.featureCard1IconBg,
                          icon: const Icon(
                            Icons.settings_backup_restore,
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                          title: 'Background running',
                          description: 'Protect you at all times',
                        ),
                        const SizedBox(height: 16),
                        FeatureCard(
                          backgroundColor: AppTheme.featureCard2Bg,
                          iconBackgroundColor: AppTheme.featureCard2IconBg,
                          icon: const Icon(
                            Icons.access_time,
                            color: Color(0xFF9810FA),
                            size: 20,
                          ),
                          title: '24/7 Monitoring',
                          description: 'Never miss any event',
                        ),
                        const SizedBox(height: 16),
                        FeatureCard(
                          backgroundColor: AppTheme.featureCard3Bg,
                          iconBackgroundColor: AppTheme.featureCard3IconBg,
                          icon: const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFE7000B),
                            size: 20,
                          ),
                          title: 'Emergency alerts',
                          description: 'Instant notifications',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Section
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    PrimaryButton(
                      text: 'Start setup',
                      onPressed: () => _handleStartSetup(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The app requires some permissions to work',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
