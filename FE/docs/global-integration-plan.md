# Sound Watcher - Global Integration Plan

## Project Overview

**Sound Watcher** is a mobile accessibility application designed to assist deaf individuals, the hard-of-hearing, and deep sleepers by continuously monitoring environmental sounds and converting them into visual and haptic alerts.

**Figma Design:** [https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Untitled?node-id=2-422&t=b4l2X0f3vBvBQB9B-1](https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Untitled?node-id=2-422&t=b4l2X0f3vBvBQB9B-1)

---

## Phase 1: Project Foundation & Setup

### 1.1 Fix Current Issues
**Priority:** Critical  
**Status:** Pending

- [ ] Fix syntax error in `main.dart` (line 14: incomplete `colorScheme.`)
- [ ] Fix syntax error in `main.dart` (line 47: incomplete `mainAxisAlignment.`)
- [ ] Remove default counter app code
- [ ] Verify Flutter SDK version compatibility (3.10.1+)

### 1.2 Project Structure Setup
**Priority:** Critical  
**Status:** Pending

Create Clean Architecture folder structure:

```
lib/
├── core/
│   ├── di/              # Dependency Injection
│   ├── constants/        # App constants
│   ├── errors/           # Error handling
│   ├── utils/            # Utility functions
│   └── theme/            # Theme configuration
├── data/
│   ├── datasources/
│   │   ├── remote/       # API clients
│   │   └── local/        # Local storage (Isar/Hive)
│   ├── models/           # Data Transfer Objects (DTOs)
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic use cases
├── features/
│   ├── dashboard/         # Main monitoring screen
│   │   ├── logic/        # Riverpod providers
│   │   └── ui/           # Dashboard widgets
│   ├── settings/         # App settings screen
│   │   ├── logic/
│   │   └── ui/
│   ├── history/          # Event history screen
│   │   ├── logic/
│   │   └── ui/
│   └── alerts/           # Alert overlay system
│       ├── logic/
│       └── ui/
├── shared/
│   ├── widgets/          # Reusable UI components
│   └── services/         # Shared services
└── main.dart
```

### 1.3 Dependencies Installation
**Priority:** Critical  
**Status:** Pending

Add all required packages to `pubspec.yaml` (see detailed list in implementation)

### 1.4 Platform Permissions Configuration
**Priority:** Critical  
**Status:** Pending

Configure Android and iOS permissions for microphone, notifications, camera/flash, and background services.

---

## Phase 2: Figma Design Extraction & Analysis

### 2.1 Extract Figma Design Specifications
**Priority:** High  
**Status:** Pending

**Figma URL:** [https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Untitled?node-id=2-422&t=b4l2X0f3vBvBQB9B-1](https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Untitled?node-id=2-422&t=b4l2X0f3vBvBQB9B-1)

**Tasks:**
- [ ] Connect Figma MCP (if not already connected)
- [ ] Extract node data for all screens/components
- [ ] Store node data in `docs/tasks/figma-design/figma-data/node-data.json`
- [ ] Break down into section files
- [ ] Download all assets
- [ ] Create design specifications document
- [ ] Document color palette (especially alert zones: Red/Yellow/Green)
- [ ] Document typography system
- [ ] Document spacing and layout guidelines

---

## Phase 3: Data Layer Implementation

### 3.1 Local Database Setup
**Priority:** High  
**Status:** Pending

- [ ] Set up Isar database initialization
- [ ] Create entities: AlertHistory, Settings, SoundDetection
- [ ] Implement local data sources (DAOs)

### 3.2 Remote Data Sources
**Priority:** Medium  
**Status:** Pending

- [ ] Create API client base class
- [ ] Implement SoundAiApiClient for audio classification
- [ ] Create DTOs for API requests/responses

### 3.3 Repository Layer
**Priority:** High  
**Status:** Pending

- [ ] Create repository interfaces (domain layer)
- [ ] Implement repositories (data layer)
- [ ] Implement caching logic

---

## Phase 4: Domain Layer Implementation

### 4.1 Entities & Use Cases
**Priority:** High  
**Status:** Pending

- [ ] Create domain entities
- [ ] Implement use cases for all business operations

---

## Phase 5: Background Service Implementation

### 5.1 Audio Recording Service
**Priority:** Critical  
**Status:** Pending

- [ ] Create background audio service
- [ ] Implement continuous audio recording
- [ ] Set up audio buffer management

### 5.2 ML Classification Service
**Priority:** Critical  
**Status:** Pending

- [ ] Download/load YAMNet TFLite model
- [ ] Create ML service
- [ ] Implement audio-to-tensor conversion
- [ ] Implement inference pipeline

### 5.3 Background Service Integration
**Priority:** Critical  
**Status:** Pending

- [ ] Configure flutter_background_service
- [ ] Set up service lifecycle management
- [ ] Handle battery optimization

---

## Phase 6: Alert System Implementation

### 6.1 Alert Controller
**Priority:** Critical  
**Status:** Pending

- [ ] Create alert controller
- [ ] Implement "Panic Mode" state management
- [ ] Coordinate flash, vibration, and UI alerts

### 6.2 Visual, Haptic & Flash Alerts
**Priority:** High  
**Status:** Pending

- [ ] Create FlashAlertOverlay widget
- [ ] Implement vibration patterns for each zone
- [ ] Implement flash light control
- [ ] Configure notification system

---

## Phase 7: UI Features Implementation

### 7.1 Dashboard Screen
**Priority:** Critical  
**Status:** Pending

- [ ] Extract dashboard design specs from Figma
- [ ] Create DashboardScreen
- [ ] Implement decibel meter visualization
- [ ] Add real-time waveform visualizer
- [ ] Display current sound classification

### 7.2 Settings & History Screens
**Priority:** High  
**Status:** Pending

- [ ] Create SettingsScreen with sensitivity controls
- [ ] Create HistoryScreen with event list
- [ ] Implement filtering and search

---

## Phase 8: State Management Integration

### 8.1 Riverpod Providers Setup
**Priority:** High  
**Status:** Pending

- [ ] Set up Riverpod code generation
- [ ] Create providers for all features
- [ ] Implement state models using Freezed

---

## Phase 9: Integration & Testing

### 9.1 Feature Integration
**Priority:** High  
**Status:** Pending

- [ ] Connect UI to state management
- [ ] Connect state management to repositories
- [ ] Test end-to-end flow

### 9.2 Error Handling & Performance
**Priority:** High  
**Status:** Pending

- [ ] Implement global error handling
- [ ] Optimize audio processing pipeline
- [ ] Optimize ML inference
- [ ] Optimize battery usage

---

## Phase 10: Polish & Documentation

### 10.1 UI Polish & Documentation
**Priority:** Medium  
**Status:** Pending

- [ ] Match Figma design pixel-perfectly
- [ ] Add smooth animations
- [ ] Update documentation
- [ ] Run linter and fix issues
- [ ] Add unit and widget tests

---

## Implementation Order

**Critical Path:**
1. Phase 1 - Foundation (blocks everything)
2. Phase 2 - Figma extraction (needed for UI)
3. Phase 3-4 - Data & Domain layers
4. Phase 5 - Background service (core functionality)
5. Phase 6 - Alert system (core functionality)
6. Phase 7 - UI features (user-facing)
7. Phase 8 - State management (connects UI to logic)
8. Phase 9 - Integration
9. Phase 10 - Polish

---

## Success Criteria

### Functional Requirements:
- [ ] App can continuously monitor audio in background
- [ ] App can classify sounds with >80% accuracy
- [ ] Alerts trigger within <5 seconds
- [ ] All three alert types work (vibration, flash, visual)
- [ ] History is saved and retrievable

### Non-Functional Requirements:
- [ ] App runs in background without significant battery drain
- [ ] UI matches Figma design
- [ ] App meets accessibility standards (WCAG 2.1 AA)
- [ ] No crashes during 1 hour of continuous operation

---

**Last Updated:** 2025-01-27  
**Status:** Planning Phase
