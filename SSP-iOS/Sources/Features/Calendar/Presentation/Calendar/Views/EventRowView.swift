//
//  EventRowView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import SwiftUI

struct EventRowView: View {
    let event: CalendarEvent
    @State private var isEditing = false
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        Button(action: {
            isEditing = true
        }) {
            HStack(alignment: .top, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if event.isAllDay {
                            Text("하루 종일")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text(event.startDate.formattedTime() + " - " + event.endDate.formattedTime())
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }

                    Text(event.title)
                        .font(.PretendardSemiBold16)
                        .foregroundStyle(Color.black.opacity(0.7))
                }

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle()) 
        .sheet(isPresented: $isEditing) {
            EventEditView(
                existingEventID: event.ekEventID,
                onComplete: {
                    viewModel.requestCalendarAccessAndLoadEvents()
                }
            )
        }
    }
}

