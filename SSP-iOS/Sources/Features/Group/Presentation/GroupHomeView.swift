//
//  GroupHomeView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupHomeView: View {
    @StateObject private var viewModel = DIContainer.shared.makeGroupHomeViewModel()

    
    @State private var showJoinSheet = false
    @State private var showCreateSheet = false

    var body: some View {
        NavigationView {
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
                    NavigationLink(destination: GroupAvailabilityView(group: group.toScheduleGroup())) {
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
            .sheet(isPresented: $showJoinSheet) {
                GroupJoinSheet { groupKey in
                    Task {
                        let success = await viewModel.joinGroup(groupKey: groupKey)
                        if success {
                            await viewModel.fetchGroups()
                        }
                    }
                }
            }

            .sheet(isPresented: $showCreateSheet) {
                GroupCreateSheet { startDate, endDate, groupName in
                    Task {
                        await viewModel.createGroup(startDate: startDate, endDate: endDate, name: groupName)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchGroups()
                }
            }

        }
    }
}

// MARK: - Button Style

struct GroupActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(configuration.isPressed ? 0.4 : 0.2))
            .cornerRadius(10)
            .foregroundColor(.black)
    }
}

// MARK: - Preview

#Preview {
    GroupHomeView()
}
