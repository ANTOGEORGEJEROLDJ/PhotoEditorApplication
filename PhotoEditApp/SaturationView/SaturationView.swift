//
//  SaturationView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct SaturationView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var saturation: Double = 1.0

    private let context = CIContext()
    private let filter = CIFilter.colorControls()

    var body: some View {
        VStack {
            if let filteredImage = applySaturation(to: viewModel.editedImage, value: saturation) {
                Image(uiImage: filteredImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)

                Slider(value: $saturation, in: 0...2)
                    .padding()

                SaveButtonViews(image: filteredImage) {
                    viewModel.updateImage(filteredImage)
                }
            } else {
                Text("Failed to load image.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Saturation")
    }

    func applySaturation(to image: UIImage, value: Double) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }

        let ciImage = CIImage(cgImage: cgImage)
        filter.inputImage = ciImage
        filter.saturation = Float(value)

        guard let output = filter.outputImage,
              let cgOutput = context.createCGImage(output, from: output.extent) else {
            return nil
        }

        return UIImage(cgImage: cgOutput)
    }
}
