// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIMisc",
    platforms: [.iOS(.v13), .macCatalyst(.v13), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUIMisc",
            targets: ["SwiftUIMisc"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sandsn123/LSSwiftMacros.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SwiftUIMisc",
            dependencies: [.product(name: "LSSwiftMacros", package: "LSSwiftMacros")]
        ),
        .testTarget(
            name: "SwiftUIMiscTests",
            dependencies: ["SwiftUIMisc"]),
    ]
)
