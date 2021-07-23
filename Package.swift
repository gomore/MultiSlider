// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MultiSlider",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "MultiSlider", targets: ["MultiSlider"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "MultiSlider", dependencies: [], path: "Sources"),
    ],
    swiftLanguageVersions: [.v5]
)
