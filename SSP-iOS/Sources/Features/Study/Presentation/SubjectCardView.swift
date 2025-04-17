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
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}
