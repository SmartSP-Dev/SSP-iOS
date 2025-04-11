// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Alamofire": .framework,
        "KakaoSDKAuth": .framework,
        "KakaoSDKCommon": .framework,
        "KakaoSDKUser": .framework,
        "KakaoSDKTalk": .framework,
    ]
)
#endif

let package = Package(
    name: "SSP-iOS",
    dependencies: [
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", from: "2.19.0")
    ]
)
