---
name: "SwiftUI Design System"
description: "Design system implementation: design tokens (colors, typography, spacing), custom ViewModifiers, ButtonStyle/ToggleStyle, environment-based theming with @Entry, reusable component library. Use when building or maintaining a design system in SwiftUI."
version: "1.0"
dependencies: ["swiftui-patterns:liquid-glass"]
---

# Design System Implementation in SwiftUI

Layered architecture for building and maintaining a SwiftUI design system.

## Architecture Layers

```
1. Design Tokens (colors, fonts, spacing)       -- Foundation
2. Custom ViewModifiers                          -- Composable styling
3. Custom Styles (ButtonStyle, ToggleStyle)      -- Interactive components
4. Environment-Based Theming                     -- App-wide theme switching
5. Reusable Component Library                    -- Built on layers 1-4
```

## Layer 1: Design Tokens

### Colors

```swift
extension Color {
    static let ds = DesignSystemColors()
}

struct DesignSystemColors {
    let primary = Color("DSPrimary")
    let secondary = Color("DSSecondary")
    let background = Color("DSBackground")
    let surface = Color("DSSurface")
    let error = Color("DSError")
    let onPrimary = Color.white
    let onBackground = Color("DSOnBackground")
    let onSurface = Color("DSOnSurface")
}

// Usage:
Text("Hello").foregroundStyle(.ds.primary)
```

### Typography

```swift
extension Font {
    static let ds = DesignSystemFonts()
}

struct DesignSystemFonts {
    let largeTitle = Font.system(size: 34, weight: .bold)
    let title = Font.system(size: 28, weight: .bold)
    let headline = Font.system(size: 17, weight: .semibold)
    let body = Font.system(size: 17, weight: .regular)
    let callout = Font.system(size: 16, weight: .regular)
    let caption = Font.system(size: 12, weight: .regular)
}

// Usage:
Text("Title").font(.ds.title)
```

### Spacing

```swift
enum DSSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// Usage:
VStack(spacing: DSSpacing.md) { ... }
```

## Layer 2: Custom ViewModifiers

```swift
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(DSSpacing.md)
            .background(Color.ds.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

// Liquid Glass variant
struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(DSSpacing.md)
            .glassEffect(in: .rect(cornerRadius: 12))
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardModifier()) }
    func glassCardStyle() -> some View { modifier(GlassCardModifier()) }
}
```

## Layer 3: Custom Component Styles

### ButtonStyle

```swift
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, DSSpacing.lg)
            .padding(.vertical, DSSpacing.sm)
            .background(Color.ds.primary)
            .foregroundStyle(Color.ds.onPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Glass button for Liquid Glass contexts
struct GlassButtonStyle: ButtonStyle {
    var tint: Color?

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .glassEffect(in: .capsule, tint: tint ?? .clear)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == GlassButtonStyle {
    static var glass: GlassButtonStyle { GlassButtonStyle() }
    static func glass(tint: Color) -> GlassButtonStyle { GlassButtonStyle(tint: tint) }
}

// Usage:
Button("Submit") { }.buttonStyle(.primary)
Button("Share") { }.buttonStyle(.glass(tint: .blue))
```

## Layer 4: Environment-Based Theming

### Modern Approach: `@Entry` Macro (macOS 15+ / iOS 18+)

```swift
struct AppTheme {
    let colors: ThemeColors
    let fonts: ThemeFonts
    let spacing: ThemeSpacing

    static let `default` = AppTheme(colors: .standard, fonts: .standard, spacing: .standard)
}

extension EnvironmentValues {
    @Entry var appTheme: AppTheme = .default
}

// Usage in views:
struct ThemedView: View {
    @Environment(\.appTheme) var theme

    var body: some View {
        Text("Hello")
            .font(theme.fonts.title)
            .foregroundStyle(theme.colors.primary)
    }
}

// Setting the theme:
ContentView().environment(\.appTheme, .default)
```

`@Entry` eliminates the boilerplate of defining a separate `EnvironmentKey` struct. Recommended for new code.

### Traditional Approach (backward compatibility)

```swift
struct AppThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.default
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}
```

## Best Practices

1. **Use `@Entry` for environment values** when targeting macOS 15+ / iOS 18+
2. **Token structs over raw values** -- group related tokens in structs (`ThemeColors`, `ThemeFonts`, `ThemeSpacing`)
3. **ViewModifiers for composition** -- encapsulate multi-modifier styling into named `ViewModifier` types
4. **Custom Styles for interactive components** -- `ButtonStyle`, `ToggleStyle`, `TextFieldStyle`
5. **Environment for cross-cutting themes** -- `@Environment` propagates themes through the entire view hierarchy
6. **Asset Catalogs for colors** -- automatic dark mode support and compile-time safety
7. **Avoid deep modifier chains** -- if applying 5+ modifiers repeatedly, extract a `ViewModifier`
8. **Glass-aware tokens** -- provide glass-specific variants (e.g., `GlassCardModifier` alongside `CardModifier`)
