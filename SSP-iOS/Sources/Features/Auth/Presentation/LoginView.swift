//
//  LoginView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// 로그인 화면을 보여주는 SwiftUI View
// ViewModel만 참조하며 내부 비즈니스 로직은 ViewModel에 위임
// 로그인 버튼 클릭 시 ViewModel의 login() 호출
import SwiftUI

struct LoginView<ViewModel: LoginViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // 앱 로고
            Image("app_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 320, height: 320)
                .shadow(radius: 10)

            // 앱 소개 문구
            VStack(alignment: .center, spacing: 10) {
                Text("일정 관리와 루틴을 한번에!")
                    .font(.PretendardBold24)
                    .multilineTextAlignment(.center)

                Text("PDF를 통해 만들어지는\n다양한 유형의 Quiz를 풀어보세요")
                    .font(.PretendardMedium16)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            // 로그인 버튼 영역
            VStack(spacing: 16) {
                // Apple 로그인 버튼
                Button(action: {
                    Task {
                        await viewModel.loginWithApple()
                    }
                }) {
                    Image("apple_login")
                        .resizable()
                        .frame(width: 300, height: 45)
                }

                // Kakao 로그인 버튼
                Button(action: {
                    Task {
                        await viewModel.loginWithKakao()
                    }
                }) {
                    Image("kakao_login")
                        .resizable()
                        .frame(width: 300, height: 45)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(.systemBackground))
    }
}



#Preview {
    LoginView(viewModel: MockLoginViewModel())
}
