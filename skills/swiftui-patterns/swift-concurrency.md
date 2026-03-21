---
name: "Swift 6.2 Concurrency for SwiftUI"
description: "Swift 6.2 concurrency changes affecting SwiftUI: default @MainActor isolation (SE-0466), nonisolated(nonsending) (SE-0461), Sendable Mutex (SE-0456), named tasks, InlineArray, Span. Use when writing async code, fixing concurrency warnings, or adopting Swift 6.2."
version: "1.0"
dependencies: []
---

# Swift 6.2 Changes Affecting SwiftUI

The most impactful Swift 6.2 changes for SwiftUI developers.

## Default `@MainActor` Isolation (SE-0466)

The single most impactful change for SwiftUI development. A new compiler setting:

```
-default-isolation MainActor
```

When enabled, **all code in your module defaults to `@MainActor`** unless explicitly marked otherwise. Eliminates the most common boilerplate in SwiftUI apps.

### Before Swift 6.2

```swift
@MainActor
class ViewModel: ObservableObject {
    @Published var items: [Item] = []

    func loadItems() async { ... }
}
```

### With Swift 6.2 Default Isolation

```swift
// Implicitly @MainActor with -default-isolation MainActor
class ViewModel: ObservableObject {
    @Published var items: [Item] = []

    func loadItems() async { ... }
}

// Explicitly opt out for background work:
nonisolated func processData() async {
    // Runs off the main actor
}
```

**Key points:**
- No more `@MainActor` annotation on every view model
- Use `nonisolated` to explicitly opt out for background work
- This is a per-module setting -- enable it in your app target's build settings

## `nonisolated(nonsending)` Default (SE-0461)

`nonisolated async` functions now stay on the caller's actor by default instead of hopping to a global executor. Eliminates a large class of sendability errors.

```swift
// In Swift 6.2, this stays on the caller's executor by default
nonisolated func fetch() async -> Data { ... }
```

**Impact:** Many `@Sendable` annotations that were previously required become unnecessary.

## Sendable Mutex (SE-0456)

`Mutex<Value>` is now always `Sendable` regardless of whether `Value` is `Sendable`. Useful for thread-safe state management outside of actors.

```swift
let cache = Mutex<[String: Data]>([:])  // Always Sendable
```

**When to use:** Shared mutable state that needs to be accessed from multiple isolation domains without an actor.

## Named Tasks

Tasks can be named for better debugging:

```swift
Task(name: "FetchUserData") {
    await loadUser()
}
```

Shows up in Instruments and crash logs.

## InlineArray (SE-0453)

Fixed-size array stored on the stack:

```swift
let fixed: InlineArray<3, Int> = [1, 2, 3]
```

**When to use:** Performance-critical code with known-size collections.

## Span and RawSpan (SE-0447, SE-0467)

Safe, non-owning access to contiguous memory:

```swift
func process(_ span: Span<Int>) {
    for value in span { print(value) }
}
```

## Other Language Changes

| Proposal | Feature | Impact |
|----------|---------|--------|
| SE-0468 | Value generics (integer generic parameters) | Type-safe fixed-size containers |
| SE-0436 | `@implementation` for Swift extensions on ObjC classes | Better ObjC interop |
| SE-0458 | Opt-in strict memory safety | Gradual memory safety adoption |
| SE-0469 | Block/discard pattern for switch/if let | Cleaner pattern matching |
| -- | Improved error messages for concurrency violations | Easier debugging |
| -- | Better type inference in closures | Less explicit typing needed |

## Migration Checklist

1. **Enable default isolation** -- add `-default-isolation MainActor` to build settings
2. **Remove redundant `@MainActor`** -- annotations on views, view models, and UI code
3. **Mark background work `nonisolated`** -- explicitly opt out where needed
4. **Review `@Sendable` annotations** -- many are now unnecessary with SE-0461
5. **Replace manual locks with `Mutex`** -- simpler, always-Sendable thread safety
6. **Name long-running tasks** -- improves debugging in Instruments
