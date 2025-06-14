//
//  SaturationView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct SaturationView: View {
    let image: UIImage
    @State private var saturation: Double = 1.0

    private let context = CIContext()
    private let filter = CIFilter.colorControls()

    var body: some View {
        VStack {
            if let filtered = applySaturation(to: image, value: saturation) {
                Image(uiImage: filtered)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Slider(value: $saturation, in: 0...2)
                .padding()
            Text("Saturation: \(String(format: "%.2f", saturation))")

            Spacer()
        }
        .navigationTitle("Saturation")
        .padding()
    }

    func applySaturation(to image: UIImage, value: Double) -> UIImage? {
        guard let cg = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cg)
        filter.inputImage = ciImage
        filter.saturation = Float(value)

        guard let output = filter.outputImage,
              let cgOutput = context.createCGImage(output, from: output.extent) else { return nil }

        return UIImage(cgImage: cgOutput)
    }
}
