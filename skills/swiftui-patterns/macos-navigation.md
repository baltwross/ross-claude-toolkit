---
name: "SwiftUI macOS Navigation"
description: "macOS navigation patterns: NavigationSplitView (2/3-column), NavigationStack, Settings scene, Form, sheets, column visibility, sidebar gotchas. Use when building macOS navigation, settings windows, or modal presentations."
version: "1.0"
dependencies: ["swiftui-patterns:liquid-glass"]
---

# macOS Navigation Patterns in SwiftUI

Patterns for macOS 26 navigation, settings, and modal presentations.

## NavigationSplitView vs NavigationStack

| Scenario | Recommendation |
|----------|---------------|
| macOS app with sidebar | `NavigationSplitView` |
| iPhone-only linear drill-down | `NavigationStack` |
| iPad/Mac multi-column | `NavigationSplitView` |
| Adaptive (phone + tablet + Mac) | `NavigationSplitView` (collapses to stack on iPhone) |
| Settings / Preferences | `TabView` + `Form` per tab |
| Complex nested navigation within a column | `NavigationStack` embedded in `NavigationSplitView` detail |

## NavigationSplitView Patterns

### Two-Column (Sidebar + Detail)

```swift
struct ContentView: View {
    @State private var selectedItem: Item?

    var body: some View {
        NavigationSplitView {
            List(items, selection: $selectedItem) { item in
                Text(item.name).tag(item)
            }
            .listStyle(.sidebar)
            .navigationTitle("Items")
        } detail: {
            if let selectedItem {
                DetailView(item: selectedItem)
            } else {
                ContentUnavailableView(
                    "No Selection",
                    systemImage: "sidebar.left",
                    description: Text("Select an item from the sidebar.")
                )
            }
        }
    }
}
```

### Three-Column (Sidebar + Content + Detail)

```swift
struct ContentView: View {
    @State private var selectedCategory: Category?
    @State private var selectedItem: Item?

    var body: some View {
        NavigationSplitView {
            List(categories, selection: $selectedCategory) { category in
                Label(category.name, systemImage: category.icon).tag(category)
            }
            .listStyle(.sidebar)
            .navigationTitle("Categories")
        } content: {
            if let category = selectedCategory {
                List(category.items, selection: $selectedItem) { item in
                    Text(item.name).tag(item)
                }
                .navigationTitle(category.name)
            }
        } detail: {
            if let item = selectedItem {
                ItemDetailView(item: item)
            }
        }
    }
}
```

### Column Visibility & Width

```swift
@State private var columnVisibility: NavigationSplitViewVisibility = .all

NavigationSplitView(columnVisibility: $columnVisibility) {
    sidebar
} content: {
    contentList
} detail: {
    detailView
}
```

Visibility: `.all`, `.doubleColumn`, `.detailOnly`, `.automatic`

```swift
NavigationSplitView {
    sidebar.navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
} detail: {
    detail
}
```

### Embedding NavigationStack in Detail

For deeper navigation within the detail column:

```swift
NavigationSplitView {
    sidebar
} detail: {
    NavigationStack(path: $detailPath) {
        DetailRoot()
            .navigationDestination(for: SubItem.self) { sub in
                SubDetailView(sub: sub)
            }
    }
}
```

## macOS NavigationSplitView Gotchas

1. **Do NOT nest NavigationStack in the sidebar** -- sidebar already handles selection-based navigation
2. **Selection binding types must match** -- `selection` binding type must match `tag`/`id` type
3. **Use `.listStyle(.sidebar)`** for sidebar column to get system styling
4. **State restoration** -- use `@SceneStorage` to persist selection across launches
5. **Toolbar placement** -- use `placement: .primaryAction` for toolbar items
6. **Lazy loading** -- detail views load lazily on selection change

## Settings / Preferences Window

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }

        Settings {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem { Label("General", systemImage: "gear") }
            AppearanceSettingsView()
                .tabItem { Label("Appearance", systemImage: "paintbrush") }
            AdvancedSettingsView()
                .tabItem { Label("Advanced", systemImage: "gearshape.2") }
        }
        .frame(width: 450)
    }
}
```

Automatically creates a Preferences window accessible via Cmd+,.

## Form Best Practices (macOS)

```swift
struct GeneralSettingsView: View {
    @AppStorage("showWelcome") var showWelcome = true
    @AppStorage("refreshInterval") var refreshInterval = 15

    var body: some View {
        Form {
            Section("Startup") {
                Toggle("Show welcome screen", isOn: $showWelcome)
            }
            Section("Updates") {
                Picker("Refresh interval", selection: $refreshInterval) {
                    Text("5 minutes").tag(5)
                    Text("15 minutes").tag(15)
                    Text("30 minutes").tag(30)
                }
            }
            Section("About") {
                LabeledContent("Version", value: "2.1.0")
                LabeledContent("Build", value: "1234")
            }
        }
        .formStyle(.grouped)
    }
}
```

| Style | Description | When to Use |
|-------|-------------|-------------|
| `.automatic` | Platform default | General use |
| `.grouped` | Grouped sections with headers | Settings/preferences |
| `.columns` | Label-value columns | macOS data entry |

**Tips:**
- `@AppStorage` for UserDefaults-backed settings
- Group related settings in `Section` with clear headers
- `Toggle` for booleans, `Picker` for enums, `TextField` for strings
- `LabeledContent` for display-only information
- Always use the `Settings` scene for the preferences window

## Sheet / Modal Patterns

```swift
.sheet(isPresented: $showSettings) {
    SettingsSheet().presentationSizing(.form)     // Form-sized
}
.sheet(isPresented: $showDetail) {
    DetailSheet().presentationSizing(.page)       // Full page
}
.sheet(isPresented: $showPopup) {
    CompactPopup().presentationSizing(.fitted)    // Fits content
}
```

On macOS 26, sheets automatically receive Liquid Glass backgrounds.
