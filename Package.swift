// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Veil",
    products: [
        .library(
            name: "Veil",
            targets: ["Veil"]),
    ],
    targets: [
        .target(
            name: "Veil",
            dependencies: []),
        .testTarget(
            name: "VeilTests",
            dependencies: ["Veil"]),
    ]
)
