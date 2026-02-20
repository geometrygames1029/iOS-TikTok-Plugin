// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TapBattle",
    platforms: [.iOS(.v15)],
    products: [.library(name: "TapBattle", targets: ["TapBattle"])],
    targets: [.target(name: "TapBattle", path: "Sources")]
)
