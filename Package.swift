// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DateFormats",
    products: [
        .library(name: "DateFormats", targets: ["DateFormats"])
    ],
    dependencies: [],
    targets: [
        .target(name: "DateFormats", dependencies: []),
        .testTarget(name: "DateFormatsTests", dependencies: ["DateFormats"])
    ]
)
