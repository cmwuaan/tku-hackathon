# DashboardScreen Design Specifications

**Figma Node:** 6:640 (Dashboard with NotificationPanel)  
**Figma URL:** [https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Hackathon?node-id=6-640](https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Hackathon?node-id=6-640)

## Design Overview

The DashboardScreen is the main monitoring screen that shows the app status, audio waveform visualization, and a slide-down notification panel.

## Layout Structure

- **Container Width:** 400px (mobile frame)
- **Container Height:** 844px
- **Layout:** Column with NotificationPanel overlay

## Components

### 1. NotificationPanel (Slide-down Panel)
- **Background:** #F3F4F6
- **Height:** 431px
- **Border Radius:** 0px 0px 24px 24px (top corners rounded)
- **Position:** Top of screen (slide-down overlay)
- **Shadow:** 0px 25px 50px -12px rgba(0, 0, 0, 0.25)

#### 1.1 Drag Handle
- **Size:** 40x4px
- **Background:** #99A1AF
- **Border Radius:** 16777200px (fully rounded)
- **Position:** Centered horizontally, 56px from top

#### 1.2 Header
- **Layout:** Row with space-between
- **Padding:** 24px horizontal
- **Height:** 48px
- **Title:** "Notifications" (20px, #101828)
- **Close Button:** 32x32px, #E5E7EB background, circular

#### 1.3 Notification List
- **Layout:** Column with 12px gap
- **Padding:** 24px horizontal
- **Scrollable:** Yes

### 2. Dashboard Content

#### 2.1 Header Section
- **Layout:** Row with space-between
- **Padding:** 24px left, 0px top
- **Height:** 52px
- **Left Side:**
  - App Icon: 48x48px, gradient background, 16px border radius
  - App Title: "Guardian" (24px, #101828)
  - Status Badge: Green dot (8x8px, #00C950) + "Monitoring" text (14px, #6A7282)
- **Right Side:**
  - Settings Button: 48x48px, #DCFCE7 background, 16px border radius

#### 2.2 WaveformVisualizer Card
- **Background:** Linear gradient (135deg)
  - Start: rgba(239, 246, 255, 1) - #EFF6FF
  - End: rgba(219, 234, 254, 1) - #DBEAFE
- **Border:** #BEDBFF, 1px
- **Border Radius:** 24px
- **Width:** 336px
- **Height:** 193.25px
- **Padding:** 25px
- **Layout:** Column with 12px gap

##### Header
- **Layout:** Row with space-between
- **Title:** "Audio Monitor" (16px, #101828)
- **Live Badge:**
  - Background: #DCFCE7
  - Border Radius: 16777200px (fully rounded)
  - Text: "Live" (12px, #008236)
  - Padding: 12px horizontal

##### Canvas Area
- **Height:** 107.25px
- **Background:** Image (waveform visualization)
- **Border Radius:** 16.4px

#### 2.3 Test Alert Button
- **Background:** #F3F4F6
- **Border Radius:** 16.4px
- **Height:** 48px
- **Width:** 336px
- **Text:** "Test Alert" (16px, #364153)
- **Text Align:** Center

## Notification Item Design

### NotificationItem Structure
- **Background:** #FFFFFF
- **Border:** #E5E7EB, 1px
- **Border Radius:** 16px
- **Padding:** 17px
- **Shadow:** 
  - 0px 1px 2px -1px rgba(0, 0, 0, 0.1)
  - 0px 1px 3px 0px rgba(0, 0, 0, 0.1)
- **Layout:** Row with gap 12px

#### Icon Container
- **Size:** 40x40px
- **Border Radius:** 16.4px
- **Gradients:**
  - Danger (Red): rgba(251, 44, 54, 1) to rgba(231, 0, 11, 1)
  - Warning (Orange): rgba(254, 154, 0, 1) to rgba(225, 113, 0, 1)

#### Content
- **Layout:** Column with 4px gap
- **Header Row:**
  - Title: "Guardian Alert" (16px, #101828)
  - Time: "2 min ago" (12px, #6A7282)
- **Description:** (14px, #4A5565)
  - Line height: 1.375em

## Color Palette

- **Background Light:** #F9FAFB
- **Background White:** #FFFFFF
- **Panel Background:** #F3F4F6
- **Text Primary:** #101828
- **Text Secondary:** #4A5565
- **Text Tertiary:** #6A7282
- **Status Green:** #00C950
- **Status Green Light:** #DCFCE7
- **Status Green Text:** #008236
- **Danger Gradient Start:** #FB2C36
- **Danger Gradient End:** #E7000B
- **Warning Gradient Start:** #FE9A00
- **Warning Gradient End:** #E17100
- **Button Background:** #F3F4F6
- **Button Text:** #364153
- **Drag Handle:** #99A1AF

## Typography

- **Heading 1:** 24px, weight 400, line-height 1.33em
- **Heading 2:** 20px, weight 400, line-height 1.4em
- **Heading 3:** 16px, weight 400, line-height 1.5em
- **Body:** 16px, weight 400, line-height 1.5em
- **Small:** 14px, weight 400, line-height 1.43em
- **Tiny:** 12px, weight 400, line-height 1.33em

## Spacing

- **Card Padding:** 17px, 25px
- **Section Gap:** 24px
- **Item Gap:** 12px
- **Text Gap:** 4px

## States

### Default State
- Notification panel can be hidden/shown
- Monitoring status active (green dot)
- Waveform visualizer showing live data

### Notification Panel States
- **Hidden:** Panel not visible
- **Visible:** Panel visible with notifications
- **Draggable:** Can be dragged up/down

## Accessibility

- **Touch Targets:** Minimum 48x48px for buttons
- **Text Contrast:** All text meets WCAG AA standards
- **Semantic Labels:** All interactive elements labeled
- **Screen Reader:** All content readable

