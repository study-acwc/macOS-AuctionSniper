import ProjectDescription

let project = Project(
    name: "macOS-AutionSniper",
    targets: [
        .target(
            name: "macOS-AutionSniper",
            destinations: .macOS,
            product: .app,
            bundleId: "io.tuist.macOS-AutionSniper",
            infoPlist: .default,
            sources: ["macOS-AutionSniper/Sources/**"],
            resources: ["macOS-AutionSniper/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "macOS-AutionSniperTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.macOS-AutionSniperTests",
            infoPlist: .default,
            sources: ["macOS-AutionSniper/Tests/**"],
            resources: [],
            dependencies: [.target(name: "macOS-AutionSniper")]
        ),
    ]
)
