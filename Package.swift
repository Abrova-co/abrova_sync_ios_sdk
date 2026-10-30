// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AbrovaSync",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AbrovaSync",
            targets: ["AbrovaSync"]
        ),
    ],
    dependencies: [
        .package(url: "https://center.abrova.ir/abrova/pn-protocol-ios.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "AbrovaSync",
            dependencies: [
                .product(name: "PNProtocol", package: "pn-protocol-ios"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AbrovaSyncTests",
            dependencies: ["AbrovaSync"],
            path: "Tests"
        ),
    ]
)
