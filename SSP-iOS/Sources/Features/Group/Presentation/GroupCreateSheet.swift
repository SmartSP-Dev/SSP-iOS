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

            Text("선택한 날짜가 포함된 일주일이 약속 기간으로 설정됩니다!")
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal)

            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)

            TextField("약속 이름 지정", text: $groupName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("확인") {
                let calendar = Calendar.current
                let weekday = calendar.component(.weekday, from: selectedDate)
                let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 2), to: selectedDate) ?? selectedDate
                let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? selectedDate
                let name = groupName.isEmpty ? "이름 없는 약속" : groupName

                onCreate(startOfWeek, endOfWeek, name)
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

