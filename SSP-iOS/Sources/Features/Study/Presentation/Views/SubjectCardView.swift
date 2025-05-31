//
//  SubjectCardView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct SubjectCardView: View {
    let subject: StudySubject
    
    var body: some View {
        HStack {
            Text(subject.name)
                .font(.headline)
            Spacer()
            Text("\(subject.time)분")
                .font(.subheadline)
        }
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 2)

    }
}
