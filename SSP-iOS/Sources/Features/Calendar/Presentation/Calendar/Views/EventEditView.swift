//
//  EventEditView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import SwiftUI
import EventKit
import EventKitUI

struct EventEditView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss

    var existingEventID: String? = nil // 기존 이벤트 ID (선택)
    var startDate: Date? = nil         // 새로 만들 경우만 사용
    var onComplete: (() -> Void)? = nil

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventStore = EKEventStore()
        let event: EKEvent

        if let existingEventID = existingEventID,
           let existing = eventStore.event(withIdentifier: existingEventID) {
            event = existing
        } else {
            event = EKEvent(eventStore: eventStore)
            event.startDate = startDate ?? Date()
            event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate ?? Date())
            event.calendar = eventStore.defaultCalendarForNewEvents
        }

        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.event = event
        controller.editViewDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(dismiss: dismiss, onComplete: onComplete)
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        let dismiss: DismissAction
        let onComplete: (() -> Void)?

        init(dismiss: DismissAction, onComplete: (() -> Void)?) {
            self.dismiss = dismiss
            self.onComplete = onComplete
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            dismiss()
            onComplete?()
        }
    }
}
