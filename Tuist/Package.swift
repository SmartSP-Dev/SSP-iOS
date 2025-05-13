// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Moya": .framework,
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
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", from: "2.19.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2")
    ]
)
