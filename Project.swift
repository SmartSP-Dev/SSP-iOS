import ProjectDescription

let project = Project(
    name: "SSP-iOS",
    targets: [
        .target(
            name: "SSP-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SSP-iOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["SSP-iOS/Sources/**"],
            resources: ["SSP-iOS/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "SSP-iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.SSP-iOSTests",
            infoPlist: .default,
            sources: ["SSP-iOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "SSP-iOS")]
        ),
    ]
)
