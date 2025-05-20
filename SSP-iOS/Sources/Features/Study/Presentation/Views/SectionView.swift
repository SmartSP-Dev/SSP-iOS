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
    let isEmpty: Bool
    let emptyMessage: String
    let content: () -> Content

    init(
        title: String,
        showsButton: Bool = false,
        contentHeight: CGFloat = 250,
        isEmpty: Bool = false,
        emptyMessage: String = "기록된 학습이 없습니다.",
        buttonAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.showsButton = showsButton
        self.buttonAction = buttonAction
        self.contentHeight = contentHeight
        self.isEmpty = isEmpty
        self.emptyMessage = emptyMessage
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
            .frame(maxWidth: .infinity)

            // 컨텐츠 영역
            VStack {
                HStack {
                    Spacer()
                    if isEmpty {
                        VStack {
                            Spacer()
                            Text(emptyMessage)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                content()
                            }
                            .padding()
                        }
                    }
                    Spacer()
                }
            }
            .frame(height: contentHeight)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

#Preview("데이터 있을 때") {
    SectionView(
        title: "이번 주 통계",
        showsButton: true,
        contentHeight: 250,
        isEmpty: false,
        buttonAction: { print("추가") }
    ) {
        VStack(spacing: 12) {
            HStack {
                Text("수학")
                Spacer()
                Text("120분")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            HStack {
                Text("영어")
                Spacer()
                Text("90분")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview("데이터 없을 때") {
    SectionView(
        title: "이번 주 통계",
        showsButton: true,
        contentHeight: 250,
        isEmpty: true,
        buttonAction: { print("추가") }
    ) {
        EmptyView()
    }
}
