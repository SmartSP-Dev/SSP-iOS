//
//  StudyView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct StudyView: View {
    @StateObject private var viewModel = StudyViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("루디")
                    .font(.PretendardSemiBold38)
                    .underline()
                Text("님 오늘도 공부를 시작해볼까요?")
                    .font(.PretendardBold16)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("이번 달 학습량")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        // 과목 추가 액션
                    } label: {
                        Image(systemName: "plus")
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 4)
                
                ForEach(viewModel.subjects) { subject in
                    SubjectCardView(subject: subject)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.top)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    StudyView()
}
