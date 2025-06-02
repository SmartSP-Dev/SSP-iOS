//
//  GroupCreateSheet.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupCreateSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var groupName: String = ""
    @State private var selectedDate: Date = Date()

    let onCreate: (Date, Date, String) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("만날 날짜를 지정해주세요!")
                .font(.headline)

            Text("선택한 날짜가 포함된 일주일이\n약속 기간으로 설정됩니다!")
                .font(.caption)
                .foregroundColor(.black.opacity(0.7))
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)

            TextField("약속 이름 지정", text: $groupName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                let (startOfWeek, endOfWeek) = selectedDate.weekBounds()
                let name = groupName.isEmpty ? "이름 없는 약속" : groupName

                onCreate(startOfWeek, endOfWeek, name)
                dismiss()
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

