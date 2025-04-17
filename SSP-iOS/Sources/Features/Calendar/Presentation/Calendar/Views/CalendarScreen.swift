//
//  CalendarScreen.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import SwiftUI

struct CalendarScreen: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        VStack(spacing: 0) {
            CalendarMonthHeader(viewModel: viewModel)

            ScrollView {
                CalendarMainBody(viewModel: viewModel)
            }
        }
    }
}
