//
//  SectionView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let showsButton: Bool
    let buttonAction: (() -> Void)?
    let contentHeight: CGFloat
    let content: () -> Content

    init(
        title: String,
        showsButton: Bool = false,
        contentHeight: CGFloat = 250,
        buttonAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.showsButton = showsButton
        self.buttonAction = buttonAction
        self.contentHeight = contentHeight
        self.content = content
    }

    var body: some View {
        VStack(spacing: 12) {
            // 헤더 영역
            HStack {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.black)

                Spacer()

                if showsButton, let action = buttonAction {
                    Button(action: action) {
                        Image(systemName: "plus")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal)

            // 컨텐츠 영역
            VStack {
                ScrollView {
                    VStack(spacing: 12) {
                        content()
                    }
                    .padding()
                }
            }
            .frame(height: contentHeight)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}



#Preview {
    SectionView(
        title: "이번 달 학습량",
        showsButton: true,
        contentHeight: 250,
        buttonAction: { print("추가 버튼 눌림") }
    ) {
        VStack(spacing: 8) {
            SubjectCardView(subject: StudySubject(name: "수학", time: 120))
            SubjectCardView(subject: StudySubject(name: "영어", time: 90))
            SubjectCardView(subject: StudySubject(name: "과학", time: 45))
            SubjectCardView(subject: StudySubject(name: "과학", time: 45))
            SubjectCardView(subject: StudySubject(name: "과학", time: 45))
        }
    }
    .padding()
}
