---
name: "SwiftUI Liquid Glass"
description: "Liquid Glass material system: glassEffect, containerGlassEffect, liquidGlassEffect, toolbar glass, window styles, migration issues. Use when implementing glass effects or updating to macOS 26 / iOS 26 visual standards."
version: "1.0"
dependencies: []
---

# Liquid Glass in SwiftUI

Apple's design language using light, depth, and translucency. Replaces the flat/vibrancy aesthetic from iOS 7 era. Shipped in macOS 26 / iOS 26 (WWDC 2025).

## Automatic Adoption (Zero Code Changes)

Rebuilding with the iOS 26 / macOS 26 SDK (Xcode 27) gives these components Liquid Glass automatically:

| Component | Behavior |
|-----------|----------|
| Navigation bars | Glass material background |
| Toolbars | Individual items as glass capsules (macOS) |
| Tab bars | Glass bar with floating appearance |
| Sidebars (`NavigationSplitView`) | Subtle glass list background |
| Sheets / Popovers | Glass-backed presentation container |
| Search bars | Glass search field |
| Alert dialogs | Prominent glass effect |

**No code changes required** for standard components.

## Core APIs

### `glassEffect(in:tint:)`

Applies glass to any view. Requires an `InsettableShape`.

```swift
Text("Label").padding().glassEffect(in: .capsule)
Image(systemName: "star.fill").padding().glassEffect(in: .circle, tint: .yellow)
Text("Card").padding().glassEffect(in: .rect(cornerRadius: 12))
Text("Custom").padding().glassEffect(in: .rect(cornerRadii: .init(topLeading: 16, bottomTrailing: 16)))
```

Shapes: `.capsule`, `.circle`, `.rect(cornerRadius:)`, `.rect(cornerRadii:)`, or any custom `InsettableShape`.

### `glassEffect(in:displayMode:)`

Controls glass visibility:

```swift
.glassEffect(in: .capsule, displayMode: .always)     // Always visible
.glassEffect(in: .capsule, displayMode: .automatic)   // System-managed (default)
.glassEffect(in: .capsule, displayMode: .never)       // Hidden (opt-out)
```

### `containerGlassEffect(in:displayMode:)`

For views containing other interactive glass elements. Creates an outer shell while children maintain inner glass regions.

```swift
HStack(spacing: 0) {
    Button { } label: { Image(systemName: "bold") }.glassEffect(in: .rect)
    Button { } label: { Image(systemName: "italic") }.glassEffect(in: .rect)
    Button { } label: { Image(systemName: "underline") }.glassEffect(in: .rect)
}
.containerGlassEffect(in: .capsule)
```

**Important**: Always use `containerGlassEffect` for grouped glass elements. Without it, child `.glassEffect()` rendering may be incorrect.

### `liquidGlassEffect()`

For **shape views only**. Creates full Liquid Glass with physical light simulation.

```swift
RoundedRectangle(cornerRadius: 20).liquidGlassEffect().frame(width: 200, height: 100)
```

Distinct from `glassEffect` -- this is for shapes, not content views.

## Glass Effect Styles

Applied via `.glassEffectStyle()`:

| Style | Description | Use Case |
|-------|-------------|----------|
| `.regular` | Standard glass, moderate translucency (default) | Primary controls, toolbars |
| `.clear` | More transparent, less visual weight | Secondary elements, subtle containers |
| `.prominentClear` | Clear with emphasized borders/highlights | FABs, elements needing emphasis |

```swift
Text("Primary").padding().glassEffect(in: .rect(cornerRadius: 12))
Text("Secondary").padding().glassEffect(in: .rect(cornerRadius: 12)).glassEffectStyle(.clear)
Text("Floating").padding().glassEffect(in: .circle).glassEffectStyle(.prominentClear)
```

## Toolbar Glass

```swift
.toolbar(glassEffect: ToolbarGlassEffect(.regular))          // Custom style
.toolbarBackgroundVisibility(.hidden, for: .toolbar)          // Hide glass
.toolbarBackgroundVisibility(.visible, for: .toolbar)         // Show glass
.toolbarBackground(.hidden, for: .navigationBar)              // Hide nav bar glass
```

## Window Styles (macOS)

```swift
WindowGroup { ContentView() }.windowStyle(.automatic)         // Auto Liquid Glass
Window("Panel", id: "panel") { PanelView() }.windowStyle(.glass)  // Full glass window
```

`.windowStyle(.glass)` makes the entire window background Liquid Glass. Ideal for floating panels, HUDs, utility windows.

## Opting Out

| Component | Opt-Out Method |
|-----------|----------------|
| Toolbar background | `.toolbarBackgroundVisibility(.hidden, for: .toolbar)` |
| Navigation bar | `.toolbarBackground(.hidden, for: .navigationBar)` |
| Tab bar | `.tabBarMinimizeBehavior(.onScrollDown)` |
| Individual views | `.glassEffect(in: ..., displayMode: .never)` |
| List/sidebar backgrounds | `.scrollContentBackground(.hidden)` |

## Best Practices

1. **Let the system work first** -- standard components adopt glass automatically
2. **Glass is for chrome, not content** -- toolbars, floating UI, controls. NOT text-heavy content areas
3. **Container first, then children** -- `.containerGlassEffect()` on parent, `.glassEffect()` on items
4. **Avoid glass-on-glass stacking** -- max 2-3 layers
5. **Tint sparingly** -- subtle system colors at default opacity
6. **Test with real content** -- glass appearance depends on what's behind it
7. **Respect accessibility** -- Liquid Glass respects Reduce Transparency and Increase Contrast
8. **Test existing customizations** -- custom nav bar appearance, toolbar backgrounds, sidebar styling

## Common Migration Issues

- **Custom toolbar backgrounds** -- custom colors may fight glass material. Remove/simplify
- **`.background(.ultraThinMaterial)`** -- looks different in the new design. Review all uses
- **Custom sidebar backgrounds** -- `.scrollContentBackground(.hidden)` + custom background may conflict
- **UINavigationBarAppearance** -- AppKit/UIKit appearance customizations may conflict with SwiftUI glass
- **Dark mode** -- glass adapts automatically, but custom colors paired with glass may lose contrast
