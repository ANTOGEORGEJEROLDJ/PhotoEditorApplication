//
//  BlackWhiteFilterView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BlackWhiteFilterView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var grayscaleAmount: Double = 1.0
    private let context = CIContext()
    private let filter = CIFilter.colorControls()

    var body: some View {
        VStack {
            if let outputImage = applyGrayscale(to: viewModel.editedImage, amount: grayscaleAmount) {
                Image(uiImage: outputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Slider(value: $grayscaleAmount, in: 0...1)
                .padding()

            SaveButtonViews(image: applyGrayscale(to: viewModel.editedImage, amount: grayscaleAmount)!) {
                viewModel.updateImage(applyGrayscale(to: viewModel.editedImage, amount: grayscaleAmount)!)
            }
        }
        .navigationTitle("Black & White")
    }

    func applyGrayscale(to image: UIImage, amount: Double) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        filter.inputImage = ciImage
        filter.saturation = Float(amount)
        guard let output = filter.outputImage,
              let cg = context.createCGImage(output, from: output.extent) else { return nil }
        return UIImage(cgImage: cg)
    }
}
