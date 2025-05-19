//
//  RoutineCardView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/4/25.
//

import SwiftUI

struct RoutineCardView: View {
    let routine: Routine
    let toggleAction: () async -> Void

    var body: some View {
        HStack {
            Image(systemName: routine.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(routine.isCompleted ? .blue : .gray)
                .font(.title2)
                .onTapGesture {
                    Task {
                        await toggleAction()
                    }
                }

            Text(routine.title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}
