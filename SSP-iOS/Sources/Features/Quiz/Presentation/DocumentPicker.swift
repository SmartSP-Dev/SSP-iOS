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
                let fileManager = FileManager.default

                // 보안 스코프 리소스 접근 시작
                let accessGranted = selectedURL.startAccessingSecurityScopedResource()
                defer {
                    if accessGranted {
                        selectedURL.stopAccessingSecurityScopedResource()
                    }
                }

                // 복사 대상 경로 (임시 디렉토리)
                let tempURL = fileManager.temporaryDirectory.appendingPathComponent(selectedURL.lastPathComponent)

                do {
                    if fileManager.fileExists(atPath: tempURL.path) {
                        try fileManager.removeItem(at: tempURL)
                    }

                    try fileManager.copyItem(at: selectedURL, to: tempURL)
                    parent.fileURL = tempURL
                } catch {
                    print("파일 복사 실패: \(error.localizedDescription)")
                    parent.fileURL = nil
                    parent.showUnsupportedFileAlert = true
                }
            } else {
                parent.fileURL = nil
                parent.showUnsupportedFileAlert = true
            }
        }

    }
}
