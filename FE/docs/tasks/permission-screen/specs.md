# PermissionScreen Design Specifications

**Figma Node:** 2:105 (PermissionScreen - Step 1/3)  
**Figma URL:** [https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Hackathon?node-id=2-105](https://www.figma.com/design/szIUVwtLdlXMaivMdHWl9w/Hackathon?node-id=2-105)

## Design Overview

The PermissionScreen is the first step (Step 1/3) in the permission setup flow. It requests permission for the app to run in the background.

## Layout Structure

- **Container Width:** 400px (mobile frame)
- **Container Height:** 844px
- **Content Padding:** 24px horizontal
- **Content Width:** 336px
- **Layout:** Column

## Components

### 1. Progress Header

- **Position:** Top, 24px from top
- **Layout:** Row with space-between
- **Left Text:** "Step 1 / 3"
- **Right Text:** "33%"
- **Font:** Inter, 14px, weight 400
- **Color:** #4A5565
- **Gap:** 8px below

### 2. Progress Bar

- **Background:** #E5E7EB
- **Height:** 8px
- **Border Radius:** 16777200px (fully rounded)
- **Progress Fill:** #155DFC (Primary Blue)
- **Progress Width:** 33% (112px out of 336px)
- **Position:** Below progress header

### 3. Large Icon

- **Size:** 128x128px
- **Position:** Centered horizontally, 92px from top
- **Background:** Linear gradient (135deg)
  - Start: rgba(219, 234, 254, 1) - #DBEAFE
  - End: rgba(190, 219, 255, 1) - #BEDBFF
- **Border Radius:** 16777200px (fully rounded)
- **Icon:** Background service icon (Material: settings_backup_restore)

### 4. Permission Card

- **Background:** #FFFFFF
- **Border:** #E5E7EB, 1px
- **Border Radius:** 24px
- **Width:** 336px
- **Height:** 363px
- **Position:** 244px from top
- **Padding:** 25px
- **Shadow:** 0px 25px 50px -12px rgba(0, 0, 0, 0.25)

#### 4.1 Card Header

- **Layout:** Row with border bottom
- **Border:** #E5E7EB, 1px bottom
- **Padding Bottom:** Implicit in layout
- **Gap:** 12px

##### App Icon

- **Size:** 40x40px
- **Background:** Linear gradient (135deg)
  - Start: rgba(43, 127, 255, 1) - #2B7FFF
  - End: rgba(20, 71, 230, 1) - #1447E6
- **Border Radius:** 10px

##### App Info

- **Layout:** Column
- **App Name:** "Guardian App"
  - Font: Inter, 14px, weight 400
  - Color: #6A7282
- **Subtitle:** "Permission request"
  - Font: Inter, 16px, weight 400
  - Color: #101828

#### 4.2 Permission Title

- **Text:** "Run in background"
- **Font:** Inter, 20px, weight 400
- **Line Height:** 1.4em (28px)
- **Letter Spacing:** -2.24609375%
- **Color:** #101828
- **Position:** 102px from card top (77px from card content start)

#### 4.3 Permission Description

- **Text:** "Allow the app to continue running when you close the screen or switch to other apps"
- **Font:** Inter, 16px, weight 400
- **Line Height:** 1.625em (26px)
- **Letter Spacing:** -1.953125%
- **Color:** #4A5565
- **Position:** 142px from card top (117px from card content start)
- **Width:** 282px

#### 4.4 Important Info Card

- **Background:** #FFFBEB
- **Border:** #FEE685, 1px
- **Border Radius:** 16px
- **Width:** 286px
- **Height:** 102px
- **Position:** 236px from card top (211px from card content start)
- **Padding:** 17px (icon), 49px left (text)
- **Layout:** Row with gap

##### Warning Icon

- **Size:** 20x20px
- **Color:** #E17100 (orange)
- **Position:** 17px from left, 19px from top

##### Info Text

- **Layout:** Column with 4px gap
- **Title:** "Important"
  - Font: Inter, 16px, weight 400
  - Color: #7B3306
- **Description:** "Required for continuous protection"
  - Font: Inter, 14px, weight 400
  - Color: #BB4D00

### 5. Action Buttons

- **Layout:** Column with 12px gap
- **Width:** 336px
- **Height:** 124px (56px + 12px + 56px)
- **Position:** 631px from top

#### 5.1 Allow Button (Primary)

- **Background:** #155DFC
- **Border Radius:** 16px
- **Height:** 56px
- **Width:** Full width
- **Text:** "Allow"
- **Text Color:** #FFFFFF
- **Font:** Inter, 16px, weight 400
- **Shadow:**
  - 0px 4px 6px -4px rgba(0, 0, 0, 0.1)
  - 0px 10px 15px -3px rgba(0, 0, 0, 0.1)

#### 5.2 Deny Button (Secondary)

- **Background:** #F3F4F6
- **Border Radius:** 16px
- **Height:** 56px
- **Width:** Full width
- **Text:** "Deny"
- **Text Color:** #364153
- **Font:** Inter, 16px, weight 400
- **No shadow**

### 6. Footer Text

- **Text:** "You can change this permission in Settings at any time"
- **Font:** Inter, 12px, weight 400
- **Line Height:** 1.3333333333333333em (16px)
- **Text Align:** Center
- **Color:** #6A7282
- **Position:** 771px from top
- **Width:** 309px (centered)

## Color Palette

- **Primary Blue:** #155DFC
- **Text Primary:** #101828
- **Text Secondary:** #4A5565
- **Text Tertiary:** #6A7282
- **Background White:** #FFFFFF
- **Background Light:** #F9FAFB
- **Progress Background:** #E5E7EB
- **Secondary Button BG:** #F3F4F6
- **Secondary Button Text:** #364153
- **Warning Background:** #FFFBEB
- **Warning Border:** #FEE685
- **Warning Icon:** #E17100
- **Warning Text Dark:** #7B3306
- **Warning Text:** #BB4D00
- **Icon Gradient Start:** #DBEAFE
- **Icon Gradient End:** #BEDBFF

## Typography

- **Font Family:** Inter
- **Heading 2:** 20px, weight 400, line-height 1.4em
- **Heading 3:** 16px, weight 400, line-height 1.5em
- **Heading 4:** 16px, weight 400, line-height 1.5em
- **Body:** 16px, weight 400, line-height 1.625em
- **Small:** 14px, weight 400, line-height 1.43em
- **Tiny:** 12px, weight 400, line-height 1.33em

## Spacing

- **Top Padding:** 24px
- **Card Padding:** 25px
- **Card Gap:** 8px (header), 12px (buttons)
- **Text Gap:** 4px
- **Section Spacing:** Various (see positions)

## States

### Default State

- All elements visible
- Buttons enabled
- Progress at 33%

### Button Pressed State

- Visual feedback (opacity or scale)
- Maintain accessibility

## Accessibility

- **Touch Targets:** Minimum 56px height for buttons
- **Text Contrast:** All text meets WCAG AA standards
- **Semantic Labels:** All interactive elements should have semantic labels
- **Screen Reader:** All text should be readable

## Notes

- This is Step 1 of 3 in the permission flow
- Progress indicator shows 33% completion
- Important info card uses warning colors (yellow/orange)
- Two action buttons: primary (Allow) and secondary (Deny)
