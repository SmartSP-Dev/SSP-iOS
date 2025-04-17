//
//  StudyStartModalView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct StudyStartModalView: View {
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("학습을 시작하시겠어요?")
                .font(.title2)
            
            Button("시작", action: onStart)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(8)
            
            Button("취소", role: .cancel) {}
                .padding()
        }
        .padding()
    }
}

//#Preview {
//    StudyStartModalView()
//}
