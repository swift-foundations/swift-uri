// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-uri",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "URI",
            targets: ["URI"]
        ),
        .library(
            name: "URI Foundation Integration",
            targets: ["URI Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-uri-standard.git", branch: "main")
    ],
    targets: [
        .target(
            name: "URI",
            dependencies: [
                .product(name: "URI Standard", package: "swift-uri-standard")
            ]
        ),
        .testTarget(
            name: "URI Tests",
            dependencies: [
                .target(name: "URI")
            ]
        ),
        .target(
            name: "URI Foundation Integration",
            dependencies: [
                .target(name: "URI")
            ]
        ),
        .testTarget(
            name: "URI Foundation Integration Tests",
            dependencies: [
                .target(name: "URI"),
                .target(name: "URI Foundation Integration"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
