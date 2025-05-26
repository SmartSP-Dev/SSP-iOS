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

    // 서버에서 받은 시간표 데이터
    let schedules: [ScheduleDay] = ScheduleDay.sampleData
    
    @State private var isRoutineAlarmOn = true
    @State private var isQuizAlarmOn = false

    var body: some View {
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
                        schedules: schedules,
                        onEdit: {
                            // 시간표 수정 화면으로 이동
                            print("시간표 수정 tapped")
                            // 예: DIContainer.shared.makeAppRouter().navigate(to: .timetableEdit)
                        }
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
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView()
    }
}
