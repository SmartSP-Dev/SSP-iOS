//
//  GroupHomeView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupHomeView: View {
    @StateObject private var viewModel = DIContainer.shared.makeGroupHomeViewModel()
    @EnvironmentObject var router: NavigationRouter

    @State private var showJoinSheet = false
    @State private var showCreateSheet = false

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Text("친구들과 약속을 잡아보세요!")
                        .font(.PretendardBold24)
                    Image(systemName: "info.circle")
                }

                HStack(spacing: 12) {
                    Button("그룹 참여하기") {
                        showJoinSheet = true
                    }
                    .buttonStyle(GroupActionButtonStyle())

                    Button("그룹 만들기") {
                        showCreateSheet = true
                    }
                    .buttonStyle(GroupActionButtonStyle())
                }

                List(viewModel.groups, id: \.groupId) { group in
                    Button(action: {
                        router.navigate(to: .groupAvailability(group: group.toScheduleGroup()))
                    }) {
                        VStack(alignment: .leading) {
                            Text(group.groupName)
                                .font(.headline)
                            Text("Group Key: \(group.groupKey)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .padding()

            // 모달: 그룹 참여
            if showJoinSheet {
                modalBackground {
                    GroupJoinSheet { groupKey in
                        Task {
                            let success = await viewModel.joinGroup(groupKey: groupKey)
                            if success {
                                await viewModel.fetchGroups()
                            }
                            showJoinSheet = false
                        }
                    }
                }
            }

            // 모달: 그룹 생성
            if showCreateSheet {
                modalBackground {
                    GroupCreateSheet { startDate, endDate, groupName in
                        Task {
                            await viewModel.createGroup(startDate: startDate, endDate: endDate, name: groupName)
                            showCreateSheet = false
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchGroups()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.goBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black.opacity(0.7))
                    Text("Back")
                        .foregroundColor(.black.opacity(0.7))
                }
            }
        }
    }

    // 공통 모달 배경 + 닫기 버튼
    @ViewBuilder
    private func modalBackground<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .overlay(
                ZStack {
                    VStack {
                        content()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 20)
                    }
                    .frame(maxWidth: 320)
                }
            )
            .onTapGesture {
                showJoinSheet = false
                showCreateSheet = false
            }
    }
}


// MARK: - Button Style

struct GroupActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(configuration.isPressed ? 0.9 : 0.7))
            .cornerRadius(10)
            .foregroundColor(.white)
    }
}

// MARK: - Preview

#Preview {
    GroupHomeView()
}
