// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DateTemplates",
    products: [
        .library(name: "DateTemplates", targets: ["DateTemplates"])
    ],
    dependencies: [],
    targets: [
        .target(name: "DateTemplates", dependencies: []),
        .testTarget(name: "DateTemplatesTests", dependencies: ["DateTemplates"])
    ]
)
