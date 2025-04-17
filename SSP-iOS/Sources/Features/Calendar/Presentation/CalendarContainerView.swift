//
//  CalendarContainerView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/14/25.
//

import SwiftUI

/// Calendar와 Routine 탭을 전환하는 컨테이너 뷰
/// - 상단 탭 바와 하단 컨텐츠 영역으로 구성됨
/// - ViewModel은 DIContainer를 통해 주입
struct CalendarContainerView: View {
    
    /// 현재 선택된 탭을 관리 (초기값은 Calendar)
    @State private var selectedTab: TabType = .calendar

    /// 사용할 탭 리스트 (추후에 탭을 확장할 수 있음)
    private let tabs: [TabType] = [.calendar, .routine]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 상단 탭 바
            CustomTabBar(tabs: tabs, selectedTab: $selectedTab)

            // MARK: - 탭 하단 구분선
            Rectangle()
                .fill(Color("mainColor800").opacity(0.2))
                .frame(height: 5)

            // MARK: - 탭에 따른 본문 콘텐츠 뷰 전환
            switch selectedTab {
            case .calendar:
                // DIContainer에서 CalendarViewModel 주입
                CalendarScreen(viewModel: DIContainer.shared.makeCalendarViewModel())
            case .routine:
                // 루틴 화면
                RoutineView(viewModel: DIContainer.shared.makeRoutineViewModel())
            }

            Spacer()
        }
    }
}

// MARK: - 커스텀 탭 바 컴포넌트
/// 주어진 탭 목록을 기반으로 상단 탭 UI를 렌더링하고, 선택 시 애니메이션과 하단 인디케이터를 이동시킴
struct CustomTabBar: View {
    let tabs: [TabType]                   // 탭 종류 배열
    @Binding var selectedTab: TabType    // 선택된 탭 상태 바인딩

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // MARK: - 탭 텍스트 목록 (수평 정렬)
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    tabLabel(title: tab.title, selected: tab == selectedTab)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedTab = tab
                            }
                        }
                }
            }

            // MARK: - 탭 선택 인디케이터 (하단 바)
            GeometryReader { geometry in
                let tabWidth = geometry.size.width / CGFloat(tabs.count)

                Rectangle()
                    .fill(Color("mainColor800")) // 메인 테마 색상
                    .frame(width: tabWidth * 0.6, height: 4)
                    .cornerRadius(2)
                    .offset(x: tabOffset(for: selectedTab, totalWidth: geometry.size.width))
                    .animation(.easeInOut, value: selectedTab)
                    .padding(.horizontal, tabWidth * 0.2) // 가운데 정렬을 위한 패딩
            }
            .frame(height: 0) // 레이아웃에는 영향 안 주게 높이 제거
        }
    }

    // MARK: - 탭 제목 라벨 스타일 정의
    /// 선택된 여부에 따라 텍스트 색상/굵기 변경
    @ViewBuilder
    private func tabLabel(title: String, selected: Bool) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.PretendardBold20)
                .fontWeight(selected ? .bold : .regular)
                .foregroundColor(selected ? Color("mainColor800") : Color("mainColor400"))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 2)
        .padding(.bottom, 4)
    }

    // MARK: - 선택된 탭의 인디케이터 위치 계산
    private func tabOffset(for tab: TabType, totalWidth: CGFloat) -> CGFloat {
        let index = tabs.firstIndex(of: tab) ?? 0
        return totalWidth / CGFloat(tabs.count) * CGFloat(index)
    }
}

// MARK: - 탭 종류 열거형
/// 각 탭의 타입과 UI 표시용 title 정의
enum TabType: CaseIterable, Hashable {
    case calendar
    case routine

    /// 각 탭의 텍스트 라벨
    var title: String {
        switch self {
        case .calendar: return "Calendar"
        case .routine: return "Routine"
        }
    }
}

#Preview {
    CalendarContainerView()
}
