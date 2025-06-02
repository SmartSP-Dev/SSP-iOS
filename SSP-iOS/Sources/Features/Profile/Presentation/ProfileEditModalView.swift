//
//  ProfileEditModalView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import SwiftUI

struct ProfileEditModalView: View {
    @State private var name: String
    @State private var university: String
    @State private var department: String

    let onSave: (String, String, String) -> Void
    let onCancel: () -> Void

    init(name: String, university: String, department: String, onSave: @escaping (String, String, String) -> Void, onCancel: @escaping () -> Void) {
        _name = State(initialValue: name)
        _university = State(initialValue: university)
        _department = State(initialValue: department)
        self.onSave = onSave
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("회원 정보 수정")
                .font(.headline)
                .padding(.top)

            VStack(spacing: 12) {
                TextField("이름", text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField("학교", text: $university)
                    .textFieldStyle(.roundedBorder)
                TextField("학과", text: $department)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            HStack(spacing: 20) {
                Button(action: onCancel) {
                    Text("취소")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(8)
                }

                Button(action: {
                    onSave(name, university, department)
                }) {
                    Text("저장")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}
