//
//  TextOverlayView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct TextOverlayView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var text = "Edit Me"
    @State private var textColor = Color.black
    @State private var fontSize: CGFloat = 32
    @State private var textPosition: CGPoint = CGPoint(x: 150, y: 150)
    @State private var dragOffset: CGSize = .zero
    @State private var showSaveAlert = false

    var body: some View {
        VStack {
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
                    position: textPosition
                ) {
                    viewModel.updateImage(combined)
                    showSaveAlert = true
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
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        return renderer.image { context in
            baseImage.draw(at: .zero)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]

            let attributedString = NSAttributedString(string: text, attributes: attrs)
            let textSize = attributedString.size()

            // Scale position from view size to actual image size
            let scale = baseImage.size.width / UIScreen.main.bounds.width
            let drawPoint = CGPoint(
                x: (position.x - textSize.width / 2) * scale,
                y: (position.y - textSize.height / 2) * scale
            )

            attributedString.draw(in: CGRect(origin: drawPoint, size: textSize))
        }
    }
}
