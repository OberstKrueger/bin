// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "bin",
    platforms: [.macOS("10.15")],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .exact("0.2.0")),
        .package(url: "https://github.com/OberstKrueger/SwiftyTerminalColors", .exact("0.1.0"))
    ],
    targets: [
        .target(
            name: "bandwidth",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftyTerminalColors", package: "SwiftyTerminalColors")
            ]
        ),
        .target(
            name: "random",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),

    ]
)
