import ProjectDescription

let project = Project(
    name: "macOS-AuctionSniper",
    settings: .settings(
        base: [
            "MACOSX_DEPLOYMENT_TARGET": "13.5"
        ]
    ),
    targets: [
        .target(
            name: "AuctionSniper",
            destinations: .macOS,
            product: .app,
            bundleId: "sweetpt365.AuctionSniper.dev",
            infoPlist: .default,
            sources: ["macOS-AuctionSniper/Sources/**"],
            resources: ["macOS-AuctionSniper/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "AuctionSniperUnitTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "sweetpt365.AuctionSniper.unitTests",
            infoPlist: .default,
            sources: ["macOS-AuctionSniper/UnitTests/**"],
            resources: [],
            dependencies: [.target(name: "AuctionSniper")]
        ),
        .target(
            name: "AuctionSniperEndToEndTests",
            destinations: .macOS,
            product: .uiTests,
            bundleId: "sweetpt365.AuctionSniper.endToEndTests",
            infoPlist: .default,
            sources: ["macOS-AuctionSniper/EndToEndTests/**"],
            dependencies: [.target(name: "AuctionSniper")]
        )
    ],
    schemes: [
        .scheme(
            name: "AuctionSniper",
            shared: true,
            buildAction: .buildAction(
                targets: [.target("AuctionSniper")]
            ),
            testAction: .targets(
                [
                    .testableTarget(target: "AuctionSniperUnitTests"),
                    .testableTarget(target: "AuctionSniperEndToEndTests")
                ]
            ),
            runAction: .runAction(configuration: .debug)
        )
    ]
)

