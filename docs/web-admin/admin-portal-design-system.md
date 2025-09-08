# Admin Portal Design System

This document describes the design system used in the Bizzan Admin Portal.

## Visual Language

### Typography

The admin portal uses system fonts with Chinese language support as primary typography.

**Headers:**
- **H1-H6:** System font stack with fallbacks
- **Font Family:** -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif
- **Chinese Support:** "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei"
- **Line Height:** 1.5 for body text, 1.2 for headings

**Body Text:**
- **Primary Font Size:** 14px (base)
- **Small Text:** 12px (table cells, meta information)
- **Large Text:** 16px (important labels)
- **Font Weight:** 400 (normal), 500 (medium), 600 (semibold)

**Special Text:**
- **Table Headers:** 11px, bold weight, centered alignment
- **Form Labels:** 14px, medium weight
- **Button Text:** 12px for small buttons, 14px for regular buttons
- **Navigation:** 14px with icon integration

### Color Palette

**Primary Colors:**
```css
@primary: #2d8cf0;           /* Main brand blue */
@light-primary: #2d8cf0;     /* Light variant */
@dark-primary: #2b85e4;      /* Dark variant */
```

**Semantic Colors:**
```css
@success: #19be6b;           /* Success green */
@warning: #ff9900;           /* Warning orange */
@error: #ed3f14;             /* Error red */
```

**Neutral Colors:**
```css
/* Background colors */
body: #f0f0f0;               /* Main background */
.white: #ffffff;             /* Card backgrounds */

/* Text colors */
@primary-text: #444;         /* Primary text */
@secondary-text: #a9a5a5;    /* Secondary text */

/* Border colors */
@border-light: #e8eaec;      /* Light borders */
@border-medium: #dddee1;     /* Medium borders */
```

**Theme Support:**
- **Light Theme:** Default with light backgrounds and dark text
- **Dark Theme:** Supported with theme switching capability
- **Brand Colors:** Consistent blue primary color across themes

### Spacing System

The spacing system follows a consistent 8px grid:

```css
/* Base spacing units */
@space-xs: 4px;              /* Extra small */
@space-sm: 8px;              /* Small */
@space-md: 16px;             /* Medium */
@space-lg: 24px;             /* Large */
@space-xl: 32px;             /* Extra large */

/* Component spacing */
.margin-top-10: 10px;        /* Custom utility */
.padding-16: 16px;           /* Standard padding */
```

**Layout Spacing:**
- **Component Margins:** 16px between major components
- **Form Field Spacing:** 16px vertical spacing
- **Card Padding:** 24px internal padding
- **Button Spacing:** 8px between buttons

### Iconography

The admin portal uses the Ionicons font icon system integrated with iView components.

**Icon Categories:**
- **Navigation Icons:** `navicon`, `arrow-down-b`, `ios-arrow-back`
- **Action Icons:** `edit`, `trash-a`, `checkmark`, `close`
- **Status Icons:** `checkmark-circled`, `alert-circled`, `information-circled`
- **Feature Icons:** `person-stalker`, `stats-bars`, `briefcase`, `android-settings`

**Usage Patterns:**
- **Menu Items:** 16px icons with consistent spacing
- **Buttons:** 14px icons within buttons
- **Status Indicators:** 12px icons for inline status
- **Loading States:** Animated `load-c` icon

## UI Component Library

### Base Components

#### Buttons

The portal uses iView button components with consistent styling:

**Button Variants:**
```html
<!-- Primary actions -->
<Button type="primary">主要操作</Button>

<!-- Secondary actions -->
<Button type="default">次要操作</Button>

<!-- Success actions -->
<Button type="success">成功操作</Button>

<!-- Warning actions -->
<Button type="warning">警告操作</Button>

<!-- Danger actions -->
<Button type="error">危险操作</Button>

<!-- Info actions -->
<Button type="info">信息操作</Button>
```

**Button Sizes:**
- **Large:** Standard size for primary actions
- **Default:** Regular size for most interactions
- **Small:** Compact size for table actions and secondary functions

**Button States:**
- **Normal:** Default interactive state
- **Hover:** Subtle color darkening
- **Active:** Pressed state with darker color
- **Disabled:** Reduced opacity with no interaction
- **Loading:** Spinner icon with disabled interaction

**Custom Button Styling:**
```css
.ivu-btn-small {
  padding: 2px 5px;
  font-size: 11px;
  border-radius: 3px;
}

.ivu-btn > .ivu-icon + span,
.ivu-btn > span + .ivu-icon {
  margin-left: 0; /* Remove default icon spacing */
}
```

#### Inputs

Form inputs follow iView standards with custom validation styling:

**Input Types:**
- **Text Input:** Standard single-line text entry
- **Textarea:** Multi-line text input with resize capability
- **Select:** Dropdown selection with search capability
- **Date Picker:** Calendar-based date selection
- **Number Input:** Numeric input with increment/decrement

**Input States:**
- **Normal:** Default state with light border
- **Focus:** Primary color border with subtle shadow
- **Error:** Red border with error message display
- **Disabled:** Grayed out appearance
- **Readonly:** Non-interactive display mode

**Validation Approach:**
- **Real-time Validation:** Immediate feedback on input change
- **Field-level Errors:** Individual error messages per field
- **Form-level Validation:** Overall form status indication
- **Success States:** Green indicators for valid inputs

#### Data Tables

Tables are central to the admin interface with extensive customization:

**Table Features:**
- **Sortable Columns:** Click headers to sort data
- **Filterable Rows:** Built-in filter controls
- **Pagination:** Page-based data navigation
- **Row Selection:** Checkbox-based selection for bulk operations
- **Expandable Rows:** Nested data display capability

**Table Styling:**
```css
.ivu-table-cell {
  font-size: 11px;
  text-align: center !important;
}

th .ivu-table-cell {
  display: inline-block;
  word-wrap: normal;
  vertical-align: middle;
  font-size: 11px;
  font-weight: bold;
}
```

**Responsive Behavior:**
- **Desktop:** Full column display with all features
- **Tablet:** Condensed columns with horizontal scroll
- **Mobile:** Stacked card layout for readability

### Composite Components

#### Modal Dialogs

Complex modal components for workflows and confirmations:

**Modal Types:**
- **Verification Modals:** Multi-step document review interfaces
- **Confirmation Dialogs:** Yes/No decision prompts
- **Form Modals:** Data entry in overlay format
- **Information Modals:** Read-only content display

**Modal Structure:**
```html
<Modal v-model="showModal" :width="800" title="标题">
  <div class="modal-body">
    <!-- Content area -->
  </div>
  <div slot="footer">
    <Button @click="handleCancel">取消</Button>
    <Button type="primary" @click="handleConfirm">确认</Button>
  </div>
</Modal>
```

**Custom Modal Styling:**
```css
.memberCheckMask, .businessCheckMask {
  position: fixed;
  z-index: 9999;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, .2);
  
  .wrapper {
    width: 800px;
    height: 450px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-37.5%, -50%);
  }
}
```

#### Card Components

Information containers with consistent styling:

**Card Usage:**
- **Dashboard Stats:** Metric display cards
- **Content Sections:** Grouped information areas
- **Form Containers:** Form organization and grouping
- **List Containers:** Table and list wrappers

**Card Features:**
- **Title Slots:** Customizable header area
- **Extra Slots:** Action buttons in header
- **Body Content:** Main content area
- **Footer Actions:** Bottom action area

### Layout Components

#### Grid System

Responsive grid layout using iView Row/Col components:

**Grid Breakpoints:**
- **xs:** < 768px (Mobile)
- **sm:** 768px - 992px (Tablet)
- **md:** 992px - 1200px (Desktop)
- **lg:** > 1200px (Large Desktop)

**Column System:**
- **24-column Grid:** Flexible layout system
- **Responsive Columns:** Automatic breakpoint adaptation
- **Offset Support:** Column positioning with offsets
- **Gutter Support:** Consistent spacing between columns

```html
<Row :gutter="16">
  <Col span="12" md="8" lg="6">
    <!-- Responsive column content -->
  </Col>
  <Col span="12" md="8" lg="6" offset="2">
    <!-- Offset column content -->
  </Col>
</Row>
```

#### Navigation Components

**Sidebar Navigation:**
- **Collapsible Menu:** Expandable/collapsible sidebar
- **Hierarchical Structure:** Multi-level menu organization
- **Icon Integration:** Consistent iconography
- **Active State Indication:** Current page highlighting

```css
.sidebar-menu-con {
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 21;
  transition: width .3s;
  
  &::-webkit-scrollbar {
    display: none; /* Hide scrollbar */
  }
}
```

**Header Navigation:**
- **Breadcrumb Trail:** Page hierarchy indication
- **User Menu:** Profile and logout controls
- **Theme Switching:** Light/dark theme toggle
- **Fullscreen Toggle:** Fullscreen mode control

## Responsive Design

### Breakpoint Strategy

The admin portal follows a desktop-first approach with responsive adaptations:

**Primary Breakpoints:**
```css
/* Desktop First */
@desktop: 1200px;
@tablet: 992px;
@mobile: 768px;
@small-mobile: 480px;
```

**Layout Adaptations:**
- **> 1200px:** Full desktop experience with sidebar
- **992px - 1200px:** Condensed desktop layout
- **768px - 992px:** Tablet layout with collapsible sidebar
- **< 768px:** Mobile layout with off-canvas navigation

### Mobile Optimizations

**Navigation Adaptations:**
- **Off-canvas Menu:** Slide-out navigation for mobile
- **Touch-friendly Targets:** Larger tap targets (44px minimum)
- **Simplified Headers:** Reduced header complexity

**Table Adaptations:**
- **Horizontal Scroll:** Preserve table structure on tablets
- **Card View:** Convert to stacked cards on mobile
- **Priority Columns:** Show most important columns first

**Form Adaptations:**
- **Full-width Inputs:** Maximum screen utilization
- **Stacked Labels:** Vertical label/input arrangement
- **Touch Keyboards:** Appropriate input types for mobile

## Accessibility Considerations

### Keyboard Navigation

**Tab Order Management:**
- **Logical Flow:** Sequential navigation through interface
- **Skip Links:** Direct navigation to main content
- **Modal Trapping:** Focus containment within modals
- **Custom Controls:** Keyboard support for complex interactions

### Screen Reader Support

**Semantic HTML:**
- **Proper Headings:** Hierarchical heading structure
- **Form Labels:** Explicit label associations
- **Button Descriptions:** Clear button purposes
- **Status Announcements:** Dynamic content updates

**ARIA Implementation:**
- **Live Regions:** Dynamic content announcements
- **State Indicators:** Current selection and status
- **Role Definitions:** Clear component purposes
- **Landmark Navigation:** Page section identification

### Color and Contrast

**Accessibility Standards:**
- **WCAG AA Compliance:** Minimum 4.5:1 contrast ratio
- **Color Independence:** No color-only information conveyance
- **High Contrast Support:** Enhanced contrast modes
- **Pattern Indicators:** Non-color status indicators

**Visual Indicators:**
- **Focus Indicators:** Visible keyboard focus
- **Error Indicators:** Clear error identification
- **Status Icons:** Visual status representation
- **Loading States:** Clear processing indication

## Component Customization

### Theme Variables

Custom CSS properties for theme consistency:

```css
:root {
  --primary-color: #2d8cf0;
  --success-color: #19be6b;
  --warning-color: #ff9900;
  --error-color: #ed3f14;
  --text-color: #444;
  --background-color: #f0f0f0;
  --border-color: #e8eaec;
}
```

### Utility Classes

Common utility classes for rapid development:

```css
/* Positioning */
.center {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.positionFixed {
  position: fixed;
  z-index: 9999;
  width: 100%;
  height: 100%;
}

/* Spacing */
.margin-top-10 { margin-top: 10px; }
.padding-16 { padding: 16px; }

/* Display */
.clearfix {
  clearfix();
}

.text-center { text-align: center; }
.text-left { text-align: left; }
.text-right { text-align: right; }
```

### Animation and Transitions

Consistent animation timing and easing:

```css
/* Standard transitions */
.fade-transition {
  transition: opacity 0.3s ease-in-out;
}

.slide-transition {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Loading animations */
.loading-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
```

## Design System Maintenance

### Component Documentation

Each component should include:
- **Usage Examples:** Code samples and implementations
- **Prop Documentation:** Available properties and configurations
- **Event Documentation:** Emitted events and handlers
- **Accessibility Notes:** Keyboard and screen reader considerations

### Style Guide Compliance

**Code Standards:**
- **CSS Organization:** Component-scoped styles with global utilities
- **Naming Conventions:** BEM methodology for custom classes
- **Variable Usage:** Consistent use of CSS custom properties
- **Documentation:** Inline comments for complex styles

**Quality Assurance:**
- **Cross-browser Testing:** Chrome, Firefox, Safari, Edge support
- **Responsive Testing:** Multiple device and screen size validation
- **Accessibility Testing:** Screen reader and keyboard navigation
- **Performance Monitoring:** CSS bundle size and render performance
