# AbrovaSync iOS SDK

Realtime database SDK for iOS with offline-first sync.

[![Swift 5.7+](https://img.shields.io/badge/Swift-5.7+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2013+%20|%20macOS%2012+-blue.svg)](https://developer.apple.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Installation

The SDK is published on [Abrova Center](https://center.abrova.ir).

### Swift Package Manager (Xcode)

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter the repository URL:
   ```
   https://center.abrova.ir/abrova/abrova-sync-ios-sdk.git
   ```
3. Select version **0.3.0**
4. Add **AbrovaSync** library to your target

### Swift Package Manager (Package.swift)

```swift
dependencies: [
    .package(url: "https://center.abrova.ir/abrova/abrova-sync-ios-sdk.git", from: "0.3.0"),
]
```

Then add the library to your target's dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "AbrovaSync", package: "abrova-sync-ios-sdk"),
    ]
)
```

### CocoaPods

Add Abrova Center's spec repository at the top of your `Podfile` (the second `source` line keeps public pods working), then the pod:

```ruby
source 'https://center.abrova.ir/abrova/specs.git'
source 'https://cdn.cocoapods.org/'

pod 'AbrovaSync', '~> 0.3'
```

Then run:

```bash
pod install
```

## Usage

Address databases and collections by the **name** shown in Abrova Console, not
by their UUID:

```swift
let todos = AbrovaSync.shared.database("my-app").collection("todos")

let doc = try await todos.add(data: ["title": "Buy milk", "completed": false])

let listener = todos.listen { documents in
    print("Todos updated: \(documents.count)")
}
```

Realtime updates are published per database name and collection name, so
`listen` only receives changes when you pass names. Passing a UUID still works
for REST calls but live updates never arrive.

### Writing a document

`set` writes the document with that id and replaces what was there:

```swift
try await todos.set(documentId: "todo-1", data: ["title": "Buy milk", "completed": false])
```

To change only some fields and keep the others, pass `merge: true`:

```swift
try await todos.set(documentId: "todo-1", data: ["completed": true], merge: true)
```

### Listening

A listener first receives the current data, then every change:

```swift
let listener = todos.listenDocument(documentId: "todo-1") { doc in
    print(doc?.getString("title") ?? "deleted")
}

let open = todos.where("completed", .equal, false).listen { documents in
    print("Open todos: \(documents.count)")
}

listener.remove()
```

Listeners are checked by your security rules. Add `onError` to hear when a
listener can't start or is stopped:

```swift
let listener = todos.where("ownerId", .equal, userId).listen { documents in
    print(documents.count)
} onError: { error in
    if let error = error as? AbrovaSyncError, error.code == "query_not_allowed" {
        print("Add a filter on: \(error.fields)")
    }
}
```

- `AbrovaSyncError.queryNotAllowed` (code `query_not_allowed`): the rules
  don't allow this query. Rules are not filters - filter on the fields named
  in `fields` so every result is one the user may read. `get()` on a query
  throws the same error.
- `AbrovaSyncError.listenerRevoked` (code `listener_revoked`): the listener
  was stopped because the rules no longer allow it (for example, the user was
  removed from a team). It is not restarted.

## Verified user identity

Security Rules check `auth.uid`. The API key ships inside your app, so the app
cannot be trusted to say who the user is - only your own server can. Have your
backend mint a short-lived user token and give the SDK a provider:

```swift
let sync = AbrovaSync.initialize(config: AbrovaSyncConfigBuilder(apiKey: "ab_live_your_api_key").build())
sync.userTokens.provider = {
    try await MyBackend.fetchSyncToken()
}
```

The SDK asks for a token when it needs one and again before the old one
expires. Your backend mints it with your project's server secret, which must
stay on your server and never ship in an app.

If your project has **Require signed user tokens** turned on in the Console, a
token is required; without it, requests are refused.

You can still call `connect()` before anyone is signed in. It returns without
an error, `sync.isAwaitingUserToken` becomes true, and the SDK connects by
itself as soon as a token is set:

```swift
sync.userTokens.set(token)   // after sign-in; pass nil after sign-out
```

If you use a `provider`, call `sync.refreshUserToken()` when the user signs in
or out. The SDK asks the provider again and connects, or reconnects, as that
user, keeping your listeners.

## Documentation

- [Abrova Cloud](https://abrova.ir/cloud)
- [Abrova Console](https://console.abrova.ir)

## License

MIT
