//
//  GroupHomeView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupHomeView: View {
    @State private var showJoinSheet = false
    @State private var showCreateSheet = false

    @State private var groups: [ScheduleGroup] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
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

                List(groups) { group in
                    NavigationLink(destination: GroupScheduleView(group: group)) {
                        VStack(alignment: .leading) {
                            Text(group.name)
                                .font(.headline)
                            Text("\(group.dateRangeString) 일정")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }

                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("친구들과 약속을 잡아보세요!")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "info.circle")
                }
            }
            .sheet(isPresented: $showJoinSheet) {
                GroupJoinSheet { newGroup in
                    groups.append(newGroup)
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                GroupCreateSheet { newGroup in
                    groups.append(newGroup)
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
