//
//  DocumentPicker.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/28/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileURL: URL?
    @Binding var showUnsupportedFileAlert: Bool  // 추가

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }

            let allowedExtensions = ["jpg", "jpeg", "png", "pdf"]
            let fileExtension = selectedURL.pathExtension.lowercased()

            if allowedExtensions.contains(fileExtension) {
                parent.fileURL = selectedURL
            } else {
                parent.fileURL = nil
                parent.showUnsupportedFileAlert = true
            }
        }
    }
}
