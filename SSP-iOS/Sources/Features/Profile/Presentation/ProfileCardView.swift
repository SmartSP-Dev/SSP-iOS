//
//  ProfileCardView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/26/25.
//

import SwiftUI

struct ProfileCardView: View {
    let name: String
    let email: String
    let provider: String
    let university: String
    let department: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text("\(university) • \(department)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("이메일")
                        .font(.caption)
                        .foregroundColor(.white)
                    Text(email)
                        .font(.footnote)
                        .foregroundColor(.white)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 2) {
                    Text("인증")
                        .font(.caption)
                        .foregroundColor(.white)
                    Text(provider)
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(12)
    }
}

#Preview {
    ProfileCardView(
        name: "홍길동",
        email: "hong@example.com",
        provider: "Kakao",
        university: "숭실대학교",
        department: "소프트웨어학부"
    )
}
