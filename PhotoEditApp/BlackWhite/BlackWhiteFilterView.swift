//
//  BlackWhiteFilterView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BlackWhiteFilterView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var grayscaleAmount: Double = 1.0  // 1 = full color, 0 = grayscale
    
    private let context = CIContext()
    private let colorFilter = CIFilter.colorControls()

    var body: some View {
        VStack {
            // Image Display
            if let image = selectedImage {
                Image(uiImage: applyGrayscale(to: image, amount: grayscaleAmount) ?? image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(Text("Select an Image").foregroundColor(.gray))
            }

            // Slider to adjust grayscale
            VStack {
                Text("Grayscale Intensity: \(String(format: "%.2f", 1 - grayscaleAmount))")
                    .font(.subheadline)
                    .padding(.bottom, 2)
                
                Slider(value: $grayscaleAmount, in: 0...1)
                    .padding(.horizontal)
                    .tint(.orange)
                
                HStack{
                    Text("0%")
                     Spacer()
                    Text("50%")
                    Spacer()
                    Text("!00%")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
            }

            // Button to pick image
            Button("Pick Image") {
                showImagePicker = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .navigationTitle("Grayscale Editor")
        .padding()
    }

    // MARK: - Grayscale Filter Logic with adjustable amount
    func applyGrayscale(to image: UIImage, amount: Double) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)

        colorFilter.inputImage = ciImage
        colorFilter.saturation = Float(amount)  // 1 = color, 0 = grayscale

        guard let outputImage = colorFilter.outputImage,
              let cgOutput = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgOutput)
    }
}
