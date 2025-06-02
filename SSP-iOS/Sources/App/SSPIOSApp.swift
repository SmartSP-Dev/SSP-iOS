import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct SSPIOSApp: App {
    @StateObject private var loginViewModel = DIContainer.shared.makeLoginViewModel()
    private let appRouter = DIContainer.shared.makeAppRouter()
    
    init() {
        if let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String {
            KakaoSDK.initSDK(appKey: kakaoKey)
        } else {
            fatalError("Kakao Native App Key가 설정되지 않았습니다.")
        }
        
        AlarmNotificationManager.shared.requestPermission()

        if UserDefaults.standard.bool(forKey: AlarmKeys.routine) {
            AlarmNotificationManager.shared.scheduleRoutineAlarm()
        }
        if UserDefaults.standard.bool(forKey: AlarmKeys.quiz) {
            AlarmNotificationManager.shared.scheduleQuizAlarm()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(loginViewModel: loginViewModel)
                .environmentObject(appRouter)
                .onOpenURL { url in
                    // 카카오톡 앱으로부터 돌아올 때 URL 처리
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
