//
//  CalendarMonthHeader.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import SwiftUI
import EventKit

struct CalendarMonthHeader: View {
    @ObservedObject var viewModel: CalendarViewModel
    @EnvironmentObject private var container: DIContainer
    @State private var showEventEditor = false

    var body: some View {
        HStack {
            Button(action: { viewModel.changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
            }

            Text(viewModel.currentMonth, formatter: monthOnlyFormatter)
                .font(.PretendardBold24)
                .foregroundStyle(Color("mainColor800"))

            Button(action: { viewModel.changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
            }

            Spacer()


            Button {
                let store = EKEventStore()
                store.requestFullAccessToEvents { granted, _ in
                    if granted {
                        DispatchQueue.main.async {
                            showEventEditor = true
                        }
                    }
                }
            } label: {
                Image(systemName: "plus.circle")
                    .font(.title2)
                    .foregroundStyle(Color("mainColor800"))
            }
            .sheet(isPresented: $showEventEditor, onDismiss: {
                viewModel.requestCalendarAccessAndLoadEvents()
            }) {
                EventEditView(startDate: viewModel.selectedDate ?? Date())
            }
            Button {
                container.appRouter.navigate(to: .groupHome)
            } label: {
                Image(systemName: "person.3.sequence")
                    .font(.title2)
                    .foregroundStyle(Color("mainColor800"))
                    .padding(.leading, 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var monthOnlyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        return formatter
    }
}

