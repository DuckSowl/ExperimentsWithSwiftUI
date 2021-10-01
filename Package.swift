// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ExperimentsWithSwiftUI",
    platforms: [
        .iOS("15.0"), .macOS(.v11)
    ],
    products: [
        .library(
            name: "ExperimentsWithSwiftUI",
            targets: ["ExperimentsWithSwiftUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ExperimentsWithSwiftUI",
            dependencies: []
        ),
    ]
)
