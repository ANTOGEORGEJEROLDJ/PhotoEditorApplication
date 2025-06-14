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
    let image: UIImage
    @State private var grayscaleAmount: Double = 1.0
    private let context = CIContext()
    private let colorFilter = CIFilter.colorControls()

    var body: some View {
        VStack {
            if let filtered = applyGrayscale(to: image, amount: grayscaleAmount) {
                Image(uiImage: filtered)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Slider(value: $grayscaleAmount, in: 0...1)
                .padding()
                .onChange(of: grayscaleAmount) { _ in }

            Text("Grayscale: \(String(format: "%.2f", 1 - grayscaleAmount))")
        }
        .navigationTitle("Black & White")
        .padding()
    }

    func applyGrayscale(to image: UIImage, amount: Double) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        colorFilter.inputImage = ciImage
        colorFilter.saturation = Float(amount)
        guard let output = colorFilter.outputImage,
              let cgOutput = context.createCGImage(output, from: output.extent) else { return nil }
        return UIImage(cgImage: cgOutput)
    }
}
