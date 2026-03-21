---
name: "SwiftUI Modern Patterns"
description: "Router skill for SwiftUI development patterns (WWDC 2025, Swift 6.2, macOS 26). Directs to focused child skills for Liquid Glass, new features, concurrency, navigation, and design systems."
version: "1.0"
dependencies: []
---

# SwiftUI Modern Patterns 2026

Hub skill for modern SwiftUI development targeting macOS 26 (Tahoe), iOS 26, Swift 6.2, Xcode 27.

## Routing Table

Load the child skill that matches your current task:

| Task involves... | Load skill |
|------------------|------------|
| Glass effects, `glassEffect()`, `containerGlassEffect()`, `liquidGlassEffect()`, Liquid Glass migration, toolbar glass, `.windowStyle(.glass)` | `swiftui-patterns:liquid-glass` |
| `FlowLayout`, `ColumnLayout`, `RichTextEditor`, scroll snapping, `presentationSizing`, SF Symbol effects, color mixing, searchable tokens, new WWDC 2025 APIs | `swiftui-patterns:new-features` |
| `@MainActor` default isolation, `nonisolated(nonsending)`, `Mutex`, Swift 6.2 concurrency, `@Sendable`, named tasks | `swiftui-patterns:swift-concurrency` |
| `NavigationSplitView`, `NavigationStack`, sidebar, column layout, `Settings` scene, `Form`, sheets, macOS-specific navigation | `swiftui-patterns:macos-navigation` |
| Design tokens, custom `ViewModifier`, `ButtonStyle`, `ToggleStyle`, environment-based theming, `@Entry`, reusable components | `swiftui-patterns:design-system` |

## General Principles

- **Let the system work first.** Standard components adopt Liquid Glass automatically with the new SDK. Do not override unless you have a specific reason.
- **Prefer SwiftUI-native APIs.** Avoid UIKit/AppKit bridging unless explicitly required.
## Sources

All patterns in this skill family are sourced from:
- Apple Developer Documentation (WWDC 2025)
- Swift Evolution proposals (SE-0466, SE-0461, SE-0456, SE-0453, SE-0447)
