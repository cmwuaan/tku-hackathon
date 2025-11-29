# WelcomeScreen Design Specifications

**Figma Node:** 1:51 (WelcomeScreen)  
**Figma URL:** [https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Hackathon?node-id=1-51](https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Hackathon?node-id=1-51)

## Design Overview

The WelcomeScreen is the first screen users see when opening the app. It introduces the app's key features and prompts users to start the setup process.

## Layout Structure

- **Container Width:** 400px (mobile frame)
- **Container Height:** 844px
- **Content Padding:** 24px vertical, 0px horizontal
- **Content Width:** 336px (centered)
- **Layout:** Column with space-between alignment

## Components

### 1. App Icon/Logo

- **Size:** 112x112px
- **Position:** Centered horizontally, 32px from top
- **Background:** Linear gradient (135deg)
  - Start: rgba(43, 127, 255, 1) - #2B7FFF
  - End: rgba(20, 71, 230, 1) - #1447E6
- **Border Radius:** 24px
- **Shadow:**
  - 0px 4px 6px -4px rgba(0, 0, 0, 0.1)
  - 0px 10px 15px -3px rgba(0, 0, 0, 0.1)

### 2. Heading 1 - "Guardian App"

- **Text:** "Guardian App"
- **Font:** Inter
- **Font Weight:** 400
- **Font Size:** 30px
- **Line Height:** 1.2em (36px)
- **Letter Spacing:** 1.318359375%
- **Color:** #101828
- **Position:** 176px from top, left-aligned

### 3. Paragraph - Description

- **Text:** "Comprehensive protection and monitoring for your device"
- **Font:** Inter
- **Font Weight:** 400
- **Font Size:** 16px
- **Line Height:** 1.5em (24px)
- **Letter Spacing:** -1.953125%
- **Text Align:** Center
- **Color:** #4A5565
- **Width:** 330px
- **Position:** 228px from top

### 4. Feature Cards Container

- **Layout:** Column
- **Gap:** 16px
- **Width:** 336px
- **Height:** 272px
- **Position:** 308px from top

#### Feature Card 1: Background running

- **Background Color:** #EFF6FF
- **Border Radius:** 16px
- **Padding:** 16px top, 16px left
- **Layout:** Row with gap 12px
- **Icon Container:**
  - Size: 40x40px
  - Background: #DBEAFE
  - Border Radius: 16.4px
- **Text Container:**
  - Gap: 4px
  - Heading: "Background running" (16px, #101828)
  - Description: "Protect you at all times" (14px, #4A5565)

#### Feature Card 2: 24/7 Monitoring

- **Background Color:** #FAF5FF
- **Border Radius:** 16px
- **Padding:** 16px top, 16px left
- **Layout:** Row with gap 12px
- **Icon Container:**
  - Size: 40x40px
  - Background: #F3E8FF
  - Border Radius: 16.4px
- **Text Container:**
  - Gap: 4px
  - Heading: "24/7 Monitoring" (16px, #101828)
  - Description: "Never miss any event" (14px, #4A5565)

#### Feature Card 3: Emergency alerts

- **Background Color:** #FEF2F2
- **Border Radius:** 16px
- **Padding:** 16px top, 16px left
- **Layout:** Row with gap 12px
- **Icon Container:**
  - Size: 40x40px
  - Background: #FFE2E2
  - Border Radius: 16.4px
- **Text Container:**
  - Gap: 4px
  - Heading: "Emergency alerts" (16px, #101828)
  - Description: "Instant notifications" (14px, #4A5565)

### 5. Action Section

- **Layout:** Column
- **Gap:** 16px
- **Width:** 336px
- **Height:** 92px

#### Primary Button - "Start setup"

- **Background Color:** #155DFC
- **Border Radius:** 16px
- **Height:** 56px
- **Width:** Full width (336px)
- **Text:** "Start setup"
- **Text Color:** #FFFFFF
- **Font:** Inter, 16px, weight 400
- **Text Align:** Center
- **Shadow:**
  - 0px 4px 6px -4px rgba(0, 0, 0, 0.1)
  - 0px 10px 15px -3px rgba(0, 0, 0, 0.1)

#### Info Text

- **Text:** "The app requires some permissions to work"
- **Font:** Inter
- **Font Weight:** 400
- **Font Size:** 14px
- **Line Height:** 1.4285714285714286em (20px)
- **Letter Spacing:** -1.07421875%
- **Text Align:** Center
- **Color:** #6A7282
- **Width:** 283px (centered)

## Color Palette

- **Primary Blue:** #155DFC
- **Text Primary:** #101828
- **Text Secondary:** #4A5565
- **Text Tertiary:** #6A7282
- **Background White:** #FFFFFF
- **Background Light:** #F9FAFB
- **Feature Card 1 BG:** #EFF6FF
- **Feature Card 1 Icon BG:** #DBEAFE
- **Feature Card 2 BG:** #FAF5FF
- **Feature Card 2 Icon BG:** #F3E8FF
- **Feature Card 3 BG:** #FEF2F2
- **Feature Card 3 Icon BG:** #FFE2E2

## Typography

- **Font Family:** Inter (system font fallback)
- **Heading 1:** 30px, weight 400, line-height 1.2em
- **Heading 3:** 16px, weight 400, line-height 1.5em
- **Body:** 16px, weight 400, line-height 1.5em
- **Small:** 14px, weight 400, line-height 1.43em

## Spacing

- **Container Padding:** 44px top, 0px sides
- **Content Padding:** 24px vertical
- **Card Gap:** 16px
- **Card Internal Gap:** 12px
- **Text Gap:** 4px
- **Section Gap:** 16px

## States

### Default State

- All elements visible
- Button enabled
- No interactions

### Button Pressed State

- Button should have visual feedback (opacity or scale)
- Maintain accessibility (minimum 48x48dp touch target)

## Accessibility

- **Touch Targets:** Minimum 48x48dp for all interactive elements
- **Text Contrast:** All text meets WCAG AA standards
- **Semantic Labels:** All interactive elements should have semantic labels
- **Screen Reader:** All text should be readable by screen readers

## Responsive Considerations

- **Mobile:** 400px width (as designed)
- **Tablet:** Scale proportionally or use max-width constraints
- **Orientation:** Portrait only (as per design)
