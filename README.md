# swift-uri

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A parsed URI value type for Swift.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-uri.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "URI", package: "swift-uri")
    ]
)
```

## License

Apache 2.0. See [LICENSE](LICENSE.md).
