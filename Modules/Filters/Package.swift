// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Filters",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Filters",
            targets: [
                "Filters"
            ]
        ),
    ],
    dependencies: [
        // Local packages
        .package(path: "../Shared"),
    ],
    targets: [
        .target(
            name: "Filters",
            dependencies: [
                // Local packages
                .product(name: "Shared", package: "Shared"),
            ]
        ),
        .testTarget(
            name: "FiltersTests",
            dependencies: [
                "Filters"
            ]
        ),
    ]
)
