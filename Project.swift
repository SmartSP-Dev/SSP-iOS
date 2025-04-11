import ProjectDescription

let projectSettings: Settings = .settings(
    configurations: [
        .debug(name: "Debug", xcconfig: "SSP-iOS/Resources/Secrets/AppConfig.xcconfig"),
        .release(name: "Release", xcconfig: "SSP-iOS/Resources/Secrets/AppConfig.xcconfig")
    ],
    defaultSettings: .recommended
)

let project = Project(
    name: "SSP-iOS",
    settings: projectSettings,
    targets: [
        .target(
            name: "SSP-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SSP-iOS",
            infoPlist: .extendingDefault(
                with: [
                    "KAKAO_API_KEY": "$(KAKAO_NATIVE_APP_KEY)",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIAppFonts": [
                        "Pretendard-Bold.otf"
                    ],
                    "CFBundleURLTypes": [
                        [
                            "CFBundleTypeRole": "Editor",
                            "CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"]
                        ]
                    ],
                    "LSApplicationQueriesSchemes": [
                        "kakaokompassauth",
                        "kakaolink",
                        "kakaoplus",
                        "kakaotalk"
                    ]
                ]
            ),
            sources: ["SSP-iOS/Sources/**"],
            resources: ["SSP-iOS/Resources/**"],
            entitlements: "SSP-iOS/Entitlements/SSP-iOS.entitlements",
            dependencies: [
                .external(name: "KakaoSDKCommon"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .external(name: "KakaoSDKTalk")
            ]
        )
    ]
)
