import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct SSPIOSApp: App {
    @StateObject private var loginViewModel = DIContainer.shared.makeLoginViewModel()

    init() {
        if let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String {
            KakaoSDK.initSDK(appKey: kakaoKey)
        } else {
            fatalError("Kakao Native App Key가 설정되지 않았습니다.")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(loginViewModel: loginViewModel)
                .onOpenURL { url in
                    // 카카오톡 앱으로부터 돌아올 때 URL 처리
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
