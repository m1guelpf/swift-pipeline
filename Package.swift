// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Pipeline",
    platforms: [
        .macOS(.v11),
        .iOS(.v16),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "Pipeline", type: .dynamic, targets: ["Pipeline"]),
    ],
    targets: [
        .target(name: "Pipeline", path: "./src"),
    ]
)
