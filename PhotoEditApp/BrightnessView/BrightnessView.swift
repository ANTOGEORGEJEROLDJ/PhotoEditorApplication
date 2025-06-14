//
//  BrightnessView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct BrightnessView: View {
    let image: UIImage
    @State private var brightness: Double = 0.0

    private let context = CIContext()
    private let filter = CIFilter.colorControls()

    var body: some View {
        VStack {
            if let filtered = applyBrightness(to: image, value: brightness) {
                Image(uiImage: filtered)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Slider(value: $brightness, in: -1...1)
                .padding()
            Text("Brightness: \(String(format: "%.2f", brightness))")

            Spacer()
        }
        .navigationTitle("Brightness")
        .padding()
    }

    func applyBrightness(to image: UIImage, value: Double) -> UIImage? {
        guard let cg = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cg)
        filter.inputImage = ciImage
        filter.brightness = Float(value)

        guard let output = filter.outputImage,
              let cgOutput = context.createCGImage(output, from: output.extent) else { return nil }

        return UIImage(cgImage: cgOutput)
    }
}
