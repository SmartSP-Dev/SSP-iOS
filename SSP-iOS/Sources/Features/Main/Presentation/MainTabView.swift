//
//  MainTabView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/9/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject private var container: DIContainer
    @ObservedObject var loginViewModel: LoginViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                CalendarContainerView()
            } label: {
                Label("Calendar", systemImage: selectedTab == 0 ? "calendar.circle.fill" : "calendar.circle")
            }

            Tab(value: 1) {
                StudyView()
            } label: {
                Label("Study", systemImage: selectedTab == 1 ? "book.fill" : "book")
            }

            Tab(value: 2) {
                QuizMainView(viewModel: container.makeQuizMainViewModel())
            } label: {
                Label("Quiz", systemImage: selectedTab == 2 ? "questionmark.circle.fill" : "questionmark.circle")
            }

            Tab(value: 3) {
                ProfileMainView(profileViewModel: container.makeProfileViewModel(), loginViewModel: loginViewModel)
            } label: {
                Label("Profile", systemImage: selectedTab == 3 ? "person.crop.circle.fill" : "person.crop.circle")
            }
        }
        .tint(Color.black.opacity(0.7))
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}
