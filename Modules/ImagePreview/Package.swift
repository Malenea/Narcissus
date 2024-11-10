// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImagePreview",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ImagePreview",
            targets: [
                "ImagePreview"
            ]
        ),
    ],
    dependencies: [
        // Local packages
        .package(path: "../Shared"),
        .package(path: "../Domain"),
        .package(path: "../Filters"),
    ],
    targets: [
        .target(
            name: "ImagePreview",
            dependencies: [
                // Local packages
                .product(name: "Shared", package: "Shared"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "Filters", package: "Filters"),
            ]
        ),
        .testTarget(
            name: "ImagePreviewTests",
            dependencies: [
                "ImagePreview"
            ]
        ),
    ]
)
