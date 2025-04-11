import SwiftUI
import KakaoSDKCommon

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
        }
    }
}

struct RootView: View {
    @ObservedObject var loginViewModel: LoginViewModel

    var body: some View {
        if loginViewModel.isLoggedIn {
            MainTabView()
        } else {
            LoginView(viewModel: loginViewModel)
        }
    }
}
