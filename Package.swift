// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-uri",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "URI",
            targets: ["URI"]
        )
    ],
    dependencies: [
        .package(path: "../../swift-standards/swift-uri-standard"),
    ],
    targets: [
        .target(
            name: "URI",
            dependencies: [
                .product(name: "URI Standard", package: "swift-uri-standard"),
            ]
        ),
        .testTarget(
            name: "URI Tests",
            dependencies: [
                "URI",
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
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
