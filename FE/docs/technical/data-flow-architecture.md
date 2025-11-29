## Data Flow Architecture

### 1. Data Source Layer (Network & Local)

The foundation layer responsible for raw data retrieval and storage.

- **Remote Data Sources** (`lib/data/datasources/remote/`):

  - Handles HTTP requests to the backend AI API.
  - Uses clients like **Dio** or **http**.
  - Example: `SoundAiApiClient.dart` sends Base64 audio chunks to the server.

- **Local Data Sources** (`lib/data/datasources/local/`):
  - Manages on-device storage for offline history, settings, and audio buffering.
  - Uses tools like **Isar**, **Hive**, or **Shared Preferences**.
  - Example: `AlertHistoryDao.dart` stores past detection events locally.

### 2. Repository Layer

- **Repositories** (`lib/data/repositories/` or `lib/domain/repositories/`):
  - Acts as the single source of truth for the app.
  - **Crucial Logic:** Decides whether to fetch data from the API (Network) or return cached data from the Local DB.
  - Transforms raw JSON/DTOs into Domain Entities used by the UI.
  - Example: `SoundRepository.dart` manages the flow of recording audio -> sending to API -> saving the result to History.

### 3. Business Logic / State Management Layer

- **BLoC / Cubit / Providers** (`lib/features/<feature>/logic/`):
  - Replaces "Hooks"; manages the state of the application.
  - Listens to UI events (e.g., "Start Listening") and executes Use Cases or Repository functions.
  - Emits states (e.g., `SoundListening`, `DangerDetected`, `Safe`).
  - Example: `DetectionCubit.dart` handles the logic for switching between "Monitoring Mode" and "Alert Mode".

### 4. UI Layer (Presentation)

- **Features** (`lib/features/`):

  - Organized by domain/screen. Each feature contains its own UI and Logic.
  - Example: `lib/features/dashboard/` contains `DashboardScreen.dart` which displays the Decibel Meter and listens to `DetectionCubit`.

- **Shared Widgets** (`lib/shared/widgets/`):
  - Reusable, dumb UI components.
  - Example: `FlashAlertOverlay.dart` (The red flashing screen component) or `WaveformVisualizer.dart`.

### 5. Dependency Injection (DI) & Core

- **Service Locator** (`lib/core/di/` or `lib/main.dart`):
  - Registers Singletons (Repositories, API Clients) so they can be injected anywhere.
  - Uses packages like **GetIt** or **Injectable**.
  - Example: Injecting the `SoundRepository` instance into the `DetectionCubit`.

---

### Summary of Flow:

1. **UI** (`DashboardScreen`) triggers an event (User presses "Start").
2. **Logic** (`DetectionCubit`) calls the **Repository** (`SoundRepository`).
3. **Repository** captures audio via **Local Source**, buffers it, and sends it to **Remote Source** (API).
4. **Logic** receives the result (e.g., "Fire Alarm"), updates state to `DangerState`.
5. **UI** listens to the state change and triggers the **Alert Widget** (Flash/Vibrate).
