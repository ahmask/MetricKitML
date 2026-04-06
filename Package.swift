// swift-tools-version: 6.0
// MetricKitML — all processing is on-device. No data leaves the device.

import PackageDescription

let package = Package(
    name: "MetricKitML",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(name: "MetricKitML", targets: ["MetricKitML"]),
        .library(name: "MetricKitMLCoreML", targets: ["MetricKitMLCoreML"]),
        .library(name: "MetricKitMLFoundation", targets: ["MetricKitMLFoundation"])
    ],
    targets: [
        // Target 1 — core only, no ML imports, works in any iOS project
        .target(
            name: "MetricKitML",
            path: "Sources/MetricKitML"
        ),
        // Target 2 — CoreML evaluation utilities, depends on MetricKitML
        .target(
            name: "MetricKitMLCoreML",
            dependencies: ["MetricKitML"],
            path: "Sources/MetricKitMLCoreML"
        ),
        // Target 3 — Foundation Model evaluation utilities, depends on MetricKitML
        .target(
            name: "MetricKitMLFoundation",
            dependencies: ["MetricKitML"],
            path: "Sources/MetricKitMLFoundation"
        ),
        // Tests
        .testTarget(
            name: "MetricKitMLTests",
            dependencies: ["MetricKitML"],
            path: "Tests/MetricKitMLTests"
        )
    ]
)
