# Web Frontend Design System

This document describes the design system used in the Bizzan Exchange Web Frontend.

## Visual Language

### Typography

**Headers:**
- **H1:** Font size 40px, color #fff, letter-spacing 5px, text-shadow for prominence
- **H2:** Font size 25px, color #000 (login forms) or #fff (main interface)
- **H3:** Font size 20px, color #828ea1, letter-spacing 2px for subtitles
- **H4-H6:** Font sizes 16px, 14px, 13px respectively with contextual coloring

**Body Text:**
- **Primary:** 14px, color #fff on dark backgrounds, #333 on light backgrounds
- **Secondary:** 12px, color #828ea1 for muted text and descriptions
- **Small:** 10px, color #979797 for fine print and disclaimers

**Special Text:**
- **Captions:** 0.7em verdana, color #828ea1, letter-spacing 0.1em
- **Labels:** 0.8em verdana, color #f0a70a, text-transform uppercase
- **Code/Monospace:** Consistent with system monospace fonts
- **Links:** Color #f0a70a with hover states

### Color Palette

**Primary Colors:**
- **Brand Primary:** #f0a70a (Golden orange) - Used for CTAs, highlights, active states
- **Brand Secondary:** #f0ac19 (Lighter orange) - Used for hover states and secondary actions
- **Success:** #00B247 (Green) - Positive price changes, success states
- **Danger:** #ff1d2c (Red) - Negative price changes, error states, warnings

**Background Colors:**
- **Primary Background:** #0b1520 (Deep dark blue) - Main application background
- **Secondary Background:** #172636 (Lighter dark blue) - Panel and card backgrounds
- **Tertiary Background:** #192330 (Medium dark blue) - Input fields and table backgrounds
- **Accent Background:** #27313e (Gray blue) - Borders, disabled states

**Text Colors:**
- **Primary Text:** #ffffff (White) - Main content text
- **Secondary Text:** #828ea1 (Light gray blue) - Secondary information
- **Muted Text:** #546886 (Muted blue gray) - Disabled text and placeholders
- **Interactive Text:** #f0a70a (Brand orange) - Links and interactive elements

**Semantic Colors:**
- **Success:** #00B247, #5AB027, #A0B61E (Green gradient) - Success states, positive changes
- **Warning:** #f0ac19, #ffa800 (Orange variants) - Warning states, pending actions
- **Error:** #ff1d2c, #bc000d, #c3333d (Red variants) - Error states, negative changes
- **Info:** #007DB6, #008FB2, #009B9E (Blue variants) - Information states

**Neutral Colors:**
- **Border Colors:** #26303d, #27313e, #273c55 (Various border weights)
- **Divider Colors:** #263142, #394253 (Section separators)
- **Shadow Colors:** rgba(0,0,0,0.1), rgba(0,0,0,0.2) (Drop shadows)

### Spacing System

**Base Spacing Unit:** 8px (used for consistent spacing calculations)

**Spacing Scale:**
- **xs:** 4px (0.5 units) - Tight spacing, icon margins
- **sm:** 8px (1 unit) - Default spacing between related elements
- **md:** 16px (2 units) - Section padding, form field spacing
- **lg:** 24px (3 units) - Component separation, card padding
- **xl:** 32px (4 units) - Page margins, major section separation
- **xxl:** 48px (6 units) - Large layout spacing

**Specific Measurements:**
- **Form padding:** 20px-30px for comfortable interaction areas
- **Button padding:** 10px-16px vertical, 16px-24px horizontal
- **Card padding:** 20px-30px for content containers
- **Page margins:** 10% for main content areas

### Iconography

**Icon System:**
- **Primary Library:** Custom iconfont with cryptocurrency and trading-specific icons
- **Secondary Icons:** iView icon system for UI components
- **Size Standards:** 16px (small), 20px (medium), 24px (large), 26px (extra large)
- **Color Applications:** Inherits text color by default, brand colors for interactive states

**Icon Categories:**
- **Cryptocurrency Icons:** BTC, ETH, USDT and other currency symbols
- **Trading Icons:** Charts, orders, portfolios, trends
- **UI Icons:** Navigation, settings, user actions
- **Social Media:** WeChat, Telegram, Twitter, Reddit, Medium

## UI Component Library

### Base Components

#### Buttons

**Primary Button:**
```css
.ivu-btn-primary {
  background-color: #f0ac19;
  border-color: #f0ac19;
  color: #fff;
  font-size: 18px;
  border-radius: 5px;
}
.ivu-btn-primary:hover {
  background: #f0ac19;
  opacity: 0.8;
}
```

**Default Button:**
```css
.ivu-btn.ivu-btn-default {
  background-color: #27313e;
  color: #fff;
  border: none;
}
.ivu-btn.ivu-btn-default:hover {
  color: #f0a70a;
}
```

**Button Variants:**
- **Primary:** Brand orange for main actions (login, trade, confirm)
- **Default:** Dark gray for secondary actions
- **Text:** Transparent with colored text for subtle actions
- **Disabled:** Reduced opacity with no-drop cursor

#### Inputs

**Standard Input:**
```css
.ivu-input {
  background-color: #192330;
  color: #fff;
  border-color: #27313e;
  border-radius: 3px;
}
.ivu-input:focus {
  border-color: #27313e;
  box-shadow: none;
}
```

**Input Group with Prepend:**
```css
.ivu-input-group-prepend {
  background-color: #27313e;
  border: 1px solid #27313e;
  color: #ccc;
}
```

**Input States:**
- **Normal:** Dark background with light border
- **Focus:** Maintains consistent styling without bright focus rings
- **Error:** Red border with error messaging
- **Disabled:** Darker background with reduced opacity
- **Placeholder:** Muted text with specific styling for login forms

#### Form Components

**Form Structure:**
- Consistent spacing between form items
- Labels positioned above inputs for clarity
- Error states with inline messaging
- Validation feedback through color and iconography

**Country Selection Dropdown:**
- Flag icons with country names
- Searchable dropdown for international users
- Phone code prefix integration

### Tables and Data Display

**Table Styling:**
```css
.ivu-table-wrapper {
  background-color: #192330;
  box-shadow: 0px 0px 4px #27313e;
}
.ivu-table-header th {
  background-color: #27313e;
  color: #ccc;
  border: none;
}
.ivu-table-row td {
  background-color: transparent;
  border-bottom: 1px solid #27313e;
  color: #fff;
}
.ivu-table-row:hover {
  background: #1e2834;
}
```

**Table Features:**
- Dark theme consistency
- Hover states for row interaction
- Sortable columns with brand-colored indicators
- Responsive table behavior on mobile devices

### Navigation Components

**Header Navigation:**
- Horizontal menu bar with dropdown support
- Brand logo positioning and sizing
- User profile dropdown with avatar
- Language selection with flag indicators
- Mobile hamburger menu transformation

**Menu Styling:**
```css
.ivu-menu-light.ivu-menu-horizontal .ivu-menu-item:hover {
  color: #828ea1;
  border-bottom: 0;
}
.ivu-menu-horizontal .ivu-menu-submenu .ivu-select-dropdown .ivu-menu-item:hover {
  background: #2f3e51;
}
```

### Modal and Overlay Components

**Modal Styling:**
```css
.ivu-modal-content {
  background-color: #192330;
  border-radius: 5px;
}
.ivu-modal-header {
  border-bottom: 1px solid #27313e;
}
.ivu-modal-header p {
  color: #fff;
}
```

**Overlay Patterns:**
- Login/registration overlays for unauthenticated users
- Loading overlays with custom spinner animations
- Confirmation dialogs with brand styling
- Error modals with clear messaging

## Layout Components

### Grid System

**Responsive Breakpoints:**
- **Mobile:** < 768px (simplified interface, mobile-specific flows)
- **Tablet:** 768px - 1024px (adapted desktop interface)
- **Desktop:** > 1024px (full-featured interface)

**Layout Patterns:**
- **Trading Interface:** Three-column layout (pairs, charts, orders)
- **User Center:** Two-column layout (navigation, content)
- **Landing Page:** Full-width sections with centered content
- **Forms:** Single-column centered layout with max-width constraints

### Container Structure

**Page Container:**
```css
.page-content {
  min-height: 100%;
  padding-bottom: 200px; /* Sticky footer accommodation */
}
```

**Content Sections:**
- Consistent padding and margin applications
- Clear visual hierarchy through spacing
- Responsive behavior across device sizes

## Responsive Design

### Breakpoint Strategy

**Mobile-First Considerations:**
- Critical features prioritized for mobile experience
- Progressive enhancement for larger screens
- Touch-friendly interaction areas (minimum 44px)
- Simplified navigation patterns

**Desktop Optimizations:**
- Advanced trading interfaces with multiple panels
- Hover states and detailed interactions
- Keyboard navigation support
- Multi-column layouts for information density

### Component Adaptations

**Navigation Adaptations:**
```css
@media screen and (max-width:768px) {
  .header_nav { display: none; }
  .login-container { display: none; }
  .footer_right { display: none; }
  .rightwrapper { display: none; }
}
```

**Mobile-Specific Components:**
- Drawer navigation for mobile menus
- Full-screen modals for forms
- Simplified trading interfaces
- Touch-optimized input controls

## Accessibility Considerations

### Color and Contrast

**Contrast Ratios:**
- Primary text on dark backgrounds meets WCAG AA standards
- Interactive elements have sufficient contrast ratios
- Color is not the only means of conveying information

### Keyboard Navigation

**Focus Management:**
- Logical tab order through interactive elements
- Visible focus indicators (though subtle for design consistency)
- Skip navigation links for main content areas

### Screen Reader Support

**Semantic HTML:**
- Proper heading hierarchy for content structure
- Form labels associated with inputs
- ARIA attributes where necessary for complex components

### Internationalization Support

**Multi-language Considerations:**
- Text expansion allowances for different languages
- RTL (Right-to-Left) layout considerations prepared
- Cultural color significance awareness
- Font support for Chinese characters and English text

## Component States and Interactions

### Interactive States

**Button States:**
- **Normal:** Base styling with clear affordance
- **Hover:** Color shift or opacity change
- **Active:** Pressed appearance with immediate feedback
- **Disabled:** Reduced opacity with appropriate cursor
- **Loading:** Spinner integration during processing

**Form Input States:**
- **Normal:** Clear interaction invitation
- **Focus:** Consistent focus styling without jarring changes
- **Error:** Red border with clear error messaging
- **Success:** Green accent for validation confirmation
- **Disabled:** Clear non-interactive appearance

### Animation and Transitions

**Transition Standards:**
- **Duration:** 0.3s for most UI transitions
- **Easing:** CSS ease-in-out for natural feeling
- **Loading Animations:** Custom spinner with brand colors
- **Page Transitions:** Smooth route changes with loading states

**Animation Applications:**
- Hover state transitions on interactive elements
- Loading spinner animations with color progression
- Modal and dropdown appearance animations
- Page transition loading indicators

The design system provides a cohesive visual language that supports the complex functionality of cryptocurrency trading while maintaining usability and accessibility standards appropriate for a global financial platform.
