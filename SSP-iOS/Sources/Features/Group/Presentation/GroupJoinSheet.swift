//
//  GroupJoinSheet.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupJoinSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupCode: String = ""

    let onJoin: (ScheduleGroup) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("그룹 코드를 입력해주세요!")
                .font(.headline)

            TextField("코드를 입력하세요", text: $groupCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("확인") {
                let joinedGroup = ScheduleGroup(name: "참여한 그룹 (\(groupCode))", dateRange: "5월 11일 ~ 5월 17일")
                onJoin(joinedGroup)
                dismiss()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    GroupJoinSheet { group in
        print("참여 그룹: \(group.name)")
    }
}


//#Preview {
//    GroupJoinSheet()
//}
