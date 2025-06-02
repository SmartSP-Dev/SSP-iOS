//
//  AlarmToggleSectionView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/26/25.
//

import SwiftUI
// TODO: - 로컬 알람
struct AlarmToggleSectionView: View {
    @Binding var isRoutineAlarmOn: Bool
    @Binding var isQuizAlarmOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("알람 설정")
                .font(.headline)

            Toggle("루틴 알람 설정", isOn: $isRoutineAlarmOn)
                .tint(.black.opacity(0.7))
            Toggle("퀴즈 복습 알람 설정", isOn: $isQuizAlarmOn)
                .tint(.black.opacity(0.7))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    @State var isRoutineAlarmOn = true
    @State var isQuizAlarmOn = true

    return AlarmToggleSectionView(
        isRoutineAlarmOn: $isRoutineAlarmOn,
        isQuizAlarmOn: $isQuizAlarmOn
    )
}
