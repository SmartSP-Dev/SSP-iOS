//
//  KeyboardObserver.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/20/25.
//

import SwiftUI
import Combine

final class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}

extension View {
    func keyboardAdaptivePadding(_ height: CGFloat) -> some View {
        self
            .padding(.bottom, height)
            .animation(.easeOut(duration: 0.25), value: height)
    }
}
