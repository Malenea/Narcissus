// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Camera",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Camera",
            targets: [
                "Camera"
            ]
        ),
    ],
    dependencies: [
        // Local packages
        .package(path: "../Shared"),
    ],
    targets: [
        .target(
            name: "Camera",
            dependencies: [
                // Local packages
                .product(name: "Shared", package: "Shared"),
            ]
        ),
        .testTarget(
            name: "CameraTests",
            dependencies: [
                "Camera"
            ]
        ),
    ]
)
