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
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.PretendardBold20)
                    .foregroundColor(Color("mainColor800"))
                    .padding(.leading, 5)
                Spacer()
                if showsButton, let action = buttonAction {
                    Button(action: action) {
                        Image(systemName: "plus")
                            .foregroundColor(Color("mainColor800"))
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 5)
                }
            }
            .padding(.top, 12)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("mainColor400"), lineWidth: 1)
                    )
                
                ScrollView {
                    VStack(spacing: 12) {
                        content()
                    }
                    .padding()
                }
            }
            .frame(height: contentHeight - 40)
            .padding(.top, 8)
            
        }
        .shadow(color: .black.opacity(0.2), radius: 8, x: 2, y: 2)
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
