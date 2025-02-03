// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Pipeline",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "Pipeline", type: .dynamic, targets: ["Pipeline"]),
    ],
    targets: [
        .target(name: "Pipeline", path: "./src"),
    ]
)
