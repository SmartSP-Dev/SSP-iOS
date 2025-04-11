//
//  CalendarContainerView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/14/25.
//

import SwiftUI

struct CalendarContainerView: View {
    @State private var isCalendarSelected: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { isCalendarSelected = true }) {
                    Text("Calendar")
                        .fontWeight(isCalendarSelected ? .bold : .regular)
                        .foregroundColor(isCalendarSelected ? .blue : .gray)
                }

                Spacer()

                Button(action: { isCalendarSelected = false }) {
                    Text("Routine")
                        .fontWeight(!isCalendarSelected ? .bold : .regular)
                        .foregroundColor(!isCalendarSelected ? .blue : .gray)
                }
            }
            .padding()
            
            Divider()
            
            if isCalendarSelected {
                CalendarView()
            } else {
                RoutineView()
            }
        }
    }
}

#Preview {
    CalendarContainerView()
}
