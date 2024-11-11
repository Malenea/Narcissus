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
        .library(
            name: "CameraMocks",
            targets: [
                "CameraMocks"
            ]
        ),
        .library(
            name: "CameraProtocols",
            targets: [
                "CameraProtocols"
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
        .target(
            name: "CameraMocks",
            dependencies: [
                // Local packages
                .product(name: "Shared", package: "Shared"),
            ]
        ),
        .target(
            name: "CameraProtocols",
            dependencies: [
                // Local packages
                .product(name: "Shared", package: "Shared"),
            ]
        ),
        .testTarget(
            name: "CameraTests",
            dependencies: [
                "Camera",
                "CameraMocks",
                "CameraProtocols"
            ]
        ),
    ]
)
