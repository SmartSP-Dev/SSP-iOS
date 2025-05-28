import SwiftUI

struct TimetableLinkEditView: View {
    @Binding var rawLink: String
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("시간표 링크 입력")
                .font(.headline)

            Text("시간표를 전체공개로 설정하지 않으면\n정상적으로 불러올 수 없습니다.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .padding(.horizontal)

            TextField("에브리타임 시간표 링크를 입력하세요", text: $rawLink)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack(spacing: 16) {
                Button(action: {
                    onCancel()
                }) {
                    Text("취소")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                }

                Button(action: {
                    onSave()
                }) {
                    Text("저장")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 32)
    }
}

struct TimetableLinkEditView_Previews: PreviewProvider {
    @State static var sampleLink = ""

    static var previews: some View {
        TimetableLinkEditView(
            rawLink: $sampleLink,
            onSave: { print("저장됨") },
            onCancel: { print("취소됨") }
        )
        .previewLayout(.sizeThatFits)
    }
}
