//
//  RoutineCardView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/4/25.
//

import SwiftUI

struct RoutineCardView: View {
    let routine: RoutineItem
    let isChecked: Bool
    let toggleAction: () -> Void

    var body: some View {
        HStack {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isChecked ? .blue : .gray)
                .font(.title2)
                .onTapGesture { toggleAction() }

            Text(routine.title)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}
