// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "knockknock",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "knockknock",
            path: "Sources/knockknock"
        )
    ]
)
