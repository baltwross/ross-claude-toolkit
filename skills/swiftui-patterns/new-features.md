---
name: "SwiftUI New Features (WWDC 2025)"
description: "New SwiftUI APIs from WWDC 2025: FlowLayout, ColumnLayout, RichTextEditor, scroll snapping, custom navigation transitions, presentationSizing, SF Symbol effects, color mixing, searchable tokens, window management."
version: "1.0"
dependencies: []
---

# SwiftUI New Features (WWDC 2025)

New views, layouts, and APIs shipping in macOS 26 / iOS 26 with Xcode 27.

## New Views

### RichTextEditor

Native rich text editing with built-in formatting:

```swift
@State private var text = RichText("Start typing...")

var body: some View {
    RichTextEditor($text)
        .richTextEditorStyle(.automatic)
        .richTextEditorToolbar(.all)
}
```

- `RichText` -- value type for rich text content
- `RichTextEditor` -- editing view (takes `Binding<RichText>`)
- `.richTextEditorStyle()` -- controls appearance
- `.richTextEditorToolbar()` -- controls formatting tools shown
- Supports: bold, italic, underline, strikethrough, alignment, lists, links, text color

## New Layouts

### FlowLayout

Built-in wrapping layout. Eliminates third-party flow layout dependencies.

```swift
FlowLayout(spacing: 8) {
    ForEach(tags) { tag in
        Text(tag.name)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.blue.opacity(0.2))
            .clipShape(Capsule())
    }
}
```

### ColumnLayout

Multi-column layout for content organization:

```swift
ColumnLayout(columns: 3, spacing: 16) {
    ForEach(items) { item in
        ItemCard(item: item)
    }
}
```

### LayoutBuilder

Result builder for composing custom layout compositions declaratively.

## Scroll View Enhancements

### Scroll Snapping

```swift
ScrollView(.horizontal) {
    LazyHStack(spacing: 16) {
        ForEach(cards) { card in
            CardView(card: card)
                .scrollSnappingAnchor(.alignment(.center))
        }
    }
}
.scrollSnapping(.aligned)
```

### Scroll Geometry

```swift
ScrollView { content }
.onScrollGeometryChange(for: CGFloat.self) { geo in
    geo.contentOffset.y
} action: { oldValue, newValue in
    scrollOffset = newValue
}
```

### Other Scroll Improvements

- `.scrollClipDisabled()` -- prevents clipping near edges
- `.scrollIndicatorsFlashOnAppear()` -- flash indicators on appear
- `.scrollPosition()` -- anchoring to edges, animated changes
- `.scrollTargetBehavior(.paging)` -- improved paging

## Navigation Updates

### Custom Navigation Transitions

```swift
.navigationTransition(.slide)
.navigationTransition(.zoom(sourceID: item.id, in: namespace))
```

### NavigationSplitView Improvements

- Better column handling and sidebar behavior
- Automatic Liquid Glass integration
- Enhanced column width control:

```swift
NavigationSplitView {
    sidebar.navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 350)
} detail: {
    detail
}
```

## Presentation Sizing

Control sheet and popover sizes:

```swift
.sheet(isPresented: $showSheet) {
    SheetContent().presentationSizing(.form)     // Fixed form-size
}
.presentationSizing(.page)     // Full page
.presentationSizing(.fitted)   // Fits content
```

`PresentationSizing` is a protocol -- custom sizing implementations are possible.

## SF Symbol Effects

```swift
Image(systemName: "bell.fill").symbolEffect(.wiggle)
Image(systemName: "arrow.clockwise").symbolEffect(.rotate)
Image(systemName: "heart").symbolEffect(.breathe)
Image(systemName: "bell.fill").symbolEffect(.wiggle, options: .repeat(.periodic(3)))
```

## Color API Updates

```swift
let mixed = Color.blue.mix(with: .red, by: 0.5)

// New system colors for Liquid Glass contexts
Color.systemBackground
Color.secondarySystemBackground
Color.tertiarySystemBackground
```

## Searchable Improvements

Token-based search with suggestions:

```swift
.searchable(text: $searchText, tokens: $tokens) { token in
    Text(token.name)
}
.searchSuggestions {
    ForEach(suggestions) { suggestion in
        Text(suggestion.name).searchCompletion(suggestion)
    }
}
```

## Window Management (macOS)

```swift
WindowGroup { ContentView() }
    .windowStyle(.automatic)
    .windowLevel(.floating)
    .defaultSize(width: 800, height: 600)

Window("Widget", id: "widget") { WidgetView() }
    .windowStyle(.glass)
```

## Other Notable Features

| Feature | API | Notes |
|---------|-----|-------|
| Drag and drop | `.draggable()` / `.dropDestination()` | Spring-loaded drop targets, better previews |
| Accessibility | `.accessibilityLabel()` overloads with `Text` | Better VoiceOver for custom controls |
| Charts | New chart types, annotations, animation | Continued Swift Charts investment |
| Toggle styles | `.toggleStyle(.switch/.checkbox/.button)` | macOS-specific styles |
| Previews | `@Previewable` expanded | More flexible preview macros |
| Sensory feedback | `.sensoryFeedback()` | New haptic patterns |
| Image rendering | `ImageRenderer` improvements | More reliable off-screen rendering |
| Section iteration | `ForEach(sectionOf:)` | Native section data iteration |
| DisclosureGroup | Improved for nested data | Better hierarchical data handling |
