//
//  TextOverlayView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//
//

import SwiftUI

struct TextOverlayView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var text = "Edit Me"
    @State private var textColor = Color.black
    @State private var fontSize: CGFloat = 32
    @State private var textPosition: CGPoint = CGPoint(x: 150, y: 150)
    @State private var dragOffset: CGSize = .zero
    @State private var showSaveAlert = false

    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    Image(uiImage: viewModel.editedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)

                    Text(text)
                        .font(.system(size: fontSize))
                        .foregroundColor(textColor)
                        .position(x: textPosition.x + dragOffset.width,
                                  y: textPosition.y + dragOffset.height)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { _ in
                                    textPosition.x += dragOffset.width
                                    textPosition.y += dragOffset.height
                                    dragOffset = .zero
                                }
                        )
                }
                .frame(height: 300)
            }

            TextField("Enter Text", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()

            ColorPicker("Text Color", selection: $textColor)
                .padding()

            Slider(value: $fontSize, in: 10...60) {
                Text("Font Size")
            }
            .padding()

            Button("Apply Text & Save") {
                if let combined = renderImageWithText(
                    baseImage: viewModel.editedImage,
                    text: text,
                    color: UIColor(textColor),
                    fontSize: fontSize,
                    position: CGPoint(x: textPosition.x + dragOffset.width, y: textPosition.y + dragOffset.height)
                ) {
                    viewModel.updateImage(combined)
                    showSaveAlert = true

                    // Optional: auto dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            SaveButtonViews(image: viewModel.editedImage) {
                viewModel.saveToCoreData()
            }

            Spacer()
        }
        .navigationTitle("Text & Color")
        .padding()
        .alert("Text Applied and Image Updated", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    func renderImageWithText(baseImage: UIImage, text: String, color: UIColor, fontSize: CGFloat, position: CGPoint) -> UIImage? {
        let imageSize = baseImage.size
        let viewWidth: CGFloat = UIScreen.main.bounds.width
        let imageViewHeight: CGFloat = 300

        // Calculate scaling from view to actual image
        let imageAspectRatio = baseImage.size.width / baseImage.size.height
        let scaledWidth = imageViewHeight * imageAspectRatio
        let scaleX = imageSize.width / scaledWidth
        let scaleY = imageSize.height / imageViewHeight

        // Final draw point
        let drawPoint = CGPoint(
            x: position.x * scaleX - (fontSize * scaleX) / 2,
            y: position.y * scaleY - (fontSize * scaleY) / 2
        )

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { context in
            baseImage.draw(at: .zero)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize * scaleX),
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]

            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(at: drawPoint)
        }
    }
}
