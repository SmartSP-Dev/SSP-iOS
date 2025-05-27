//
//  ProfileMainView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/25/25.
//

import SwiftUI

struct ProfileMainView: View {
    let name: String = "로즈"
    let email: String = "rose@kakao.com"
    let provider: String = "Kakao"
    let university: String = "숭실대학교"
    let department: String = "컴퓨터학부"

    @State private var rawTimetableLink: String = ""
    @State private var myTimetableLink: String? = nil
    @State private var isLinkEditPresented: Bool = false


    @State private var isRoutineAlarmOn = true
    @State private var isQuizAlarmOn = false
    
    @StateObject var viewModel = DIContainer.shared.makeTimetableLinkViewModel()


    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        ProfileCardView(
                            name: name,
                            email: email,
                            provider: provider,
                            university: university,
                            department: department
                        )

                        TimetableCardView(
                            schedules: viewModel.schedules,
                            onEdit: {
                                isLinkEditPresented = true
                            },
                            timetableLink: myTimetableLink
                        )

                        AlarmToggleSectionView(
                            isRoutineAlarmOn: $isRoutineAlarmOn,
                            isQuizAlarmOn: $isQuizAlarmOn
                        )
                    }
                    .padding()
                }
                .navigationTitle("프로필")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // 프로필 수정
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                        }
                    }
                }
            }

            if isLinkEditPresented {
                Color.black.opacity(0.5) // 배경 dim
                    .ignoresSafeArea()

                TimetableLinkEditView(
                    rawLink: $viewModel.rawLink,
                    onSave: {
                        viewModel.saveLink()
                        viewModel.fetchMyTimetable()
                        isLinkEditPresented = false
                    },
                    onCancel: {
                        isLinkEditPresented = false
                    }
                )
            }
        }
        .onAppear {
            viewModel.fetchMyTimetable()
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView()
    }
}
