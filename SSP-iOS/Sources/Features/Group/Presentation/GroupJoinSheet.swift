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

    let onJoin: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("그룹 코드를 입력해주세요!")
                .font(.headline)

            TextField("코드를 입력하세요", text: $groupCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                guard !groupCode.isEmpty else { return }
                onJoin(groupCode)
            }) {
                Text("확인")
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.7))
            .cornerRadius(8)
            
        }
        .padding()
    }
}

