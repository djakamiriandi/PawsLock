// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PawsLock",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "PawsLock", targets: ["PawsLock"])
    ],
    targets: [
        .executableTarget(
            name: "PawsLock",
            dependencies: [],
            path: "Sources/PawsLock"
        )
    ]
)
