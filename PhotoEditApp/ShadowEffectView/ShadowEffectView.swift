//
//  ShadowEffectView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct ShadowEffectView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var radius: CGFloat = 5
    @State private var offset: CGSize = CGSize(width: 5, height: 5)
    @State private var color: Color = .black
    @State private var showSaveAlert = false

    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: viewModel.editedImage)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: color, radius: radius, x: offset.width, y: offset.height)
            }
            .frame(height: 300)

            ColorPicker("Shadow Color", selection: $color)
                .padding()

            Slider(value: $radius, in: 0...20) {
                Text("Radius")
            }
            .padding()

            HStack {
                Text("Offset X")
                Slider(value: $offset.width, in: -20...20)
            }
            .padding()

            HStack {
                Text("Offset Y")
                Slider(value: $offset.height, in: -20...20)
            }
            .padding()

            Button("Apply Shadow & Save") {
                if let shadowedImage = renderImageWithShadow(
                    baseImage: viewModel.editedImage,
                    radius: radius,
                    offset: offset,
                    color: UIColor(color)
                ) {
                    viewModel.updateImage(shadowedImage)
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
        .navigationTitle("Shadow Effect")
        .alert("Shadow Applied and Image Updated", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    func renderImageWithShadow(baseImage: UIImage, radius: CGFloat, offset: CGSize, color: UIColor) -> UIImage? {
        let size = CGSize(width: baseImage.size.width + abs(offset.width) * 2,
                          height: baseImage.size.height + abs(offset.height) * 2)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let rect = CGRect(
                x: abs(offset.width),
                y: abs(offset.height),
                width: baseImage.size.width,
                height: baseImage.size.height
            )

            context.cgContext.setShadow(offset: offset, blur: radius, color: color.cgColor)
            baseImage.draw(in: rect)
        }
        return image
    }
}
