//
//  ProfileMainView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/25/25.
//

import SwiftUI

struct ProfileMainView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject private var timetableViewModel = DIContainer.shared.makeTimetableLinkViewModel()

    @State private var rawTimetableLink: String = ""
    @State private var myTimetableLink: String? = nil
    @State private var isLinkEditPresented: Bool = false
    @State private var isRoutineAlarmOn = true
    @State private var isQuizAlarmOn = false
    @State private var isProfileEditPresented: Bool = false

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        if let profile = profileViewModel.profile {
                            ProfileCardView(
                                name: profile.name.isEmpty ? "이름 없음" : profile.name,
                                email: profile.email.isEmpty ? "이메일 없음" : profile.email,
                                provider: profile.provider,
                                university: profile.university.isEmpty ? "-" : profile.university,
                                department: profile.department.isEmpty ? "-" : profile.department
                            )
                        } else {
                            Text("상단의 버튼을 눌러 프로필을 설정해주세요.")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .padding()
                        }

                        TimetableCardView(
                            schedules: timetableViewModel.schedules,
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
                            isProfileEditPresented = true
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                        }
                    }
                }
            }

            if isLinkEditPresented {
                Color.black.opacity(0.5).ignoresSafeArea()
                TimetableLinkEditView(
                    rawLink: $timetableViewModel.rawLink,
                    onSave: {
                        Task {
                            timetableViewModel.saveLink()
                            await timetableViewModel.fetchMyTimetable()
                            isLinkEditPresented = false
                        }
                    },
                    onCancel: {
                        isLinkEditPresented = false
                    }
                )
            }

            if isProfileEditPresented {
                Color.black.opacity(0.5).ignoresSafeArea().zIndex(1)
                ProfileEditModalView(
                    name: profileViewModel.profile?.name ?? "",
                    university: profileViewModel.profile?.university ?? "",
                    department: profileViewModel.profile?.department ?? "",
                    onSave: { newName, newUniv, newDept in
                        Task {
                            await profileViewModel.updateProfile(name: newName, university: newUniv, department: newDept)
                            await profileViewModel.fetchProfile()
                            isProfileEditPresented = false
                        }
                    },

                    onCancel: {
                        isProfileEditPresented = false
                    }
                )
                .zIndex(2)
            }
        }
        .onAppear {
            Task {
                await profileViewModel.fetchProfile()
                await timetableViewModel.fetchMyTimetable()

            }
        }
    }
}
