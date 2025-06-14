//
//  AdvancedEditorView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct AdvancedEditorView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var grayscaleAmount: Double = 1.0
    @State private var cropMode: CropMode = .none
    @State private var showSaveAlert = false
    
    private let context = CIContext()
    private let colorFilter = CIFilter.colorControls()

    enum CropMode: String, CaseIterable, Identifiable {
        case none, crop_1_1, crop_4_3, crop_16_9
        var id: String { rawValue }
    }

    var body: some View {
        VStack(spacing: 10) {
            // MARK: Image Display
            if let image = selectedImage {
                GeometryReader { geo in
                    ZStack {
                        Image(uiImage: applyGrayscale(to: image, amount: grayscaleAmount) ?? image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                        
                        if cropMode != .none {
                            CropOverlay(ratio: cropRatio(for: cropMode))
                                .stroke(Color.blue, lineWidth: 2)
                                .frame(width: geo.size.width * 0.8, height: geo.size.width * 0.8 / cropRatio(for: cropMode))
                        }
                    }
                }
                .frame(height: 350)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(Text("Select an Image").foregroundColor(.gray))
            }

            // MARK: Grayscale Slider
            HStack {
                Text("Grayscale")
                Slider(value: $grayscaleAmount, in: 0...1)
            }.padding(.horizontal)

            // MARK: Crop Options
            Picker("Crop Mode", selection: $cropMode) {
                ForEach(CropMode.allCases) { mode in
                    Text(mode.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // MARK: Buttons
            HStack {
                Button("Pick Image") {
                    showImagePicker = true
                }
                .buttonStyle(BasicButtonStyle())

                Button("Save") {
                    saveFinalImage()
                }
                .buttonStyle(BasicButtonStyle())
            }

            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(title: Text("Saved!"), message: Text("Your edited image has been saved."), dismissButton: .default(Text("OK")))
        }
        .padding()
        .navigationTitle("Photo Editor")
    }

    // MARK: Grayscale Filter
    func applyGrayscale(to image: UIImage, amount: Double) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)

        colorFilter.inputImage = ciImage
        colorFilter.saturation = Float(amount)

        guard let outputImage = colorFilter.outputImage,
              let cgOutput = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgOutput)
    }

    // MARK: Crop Ratios
    func cropRatio(for mode: CropMode) -> CGFloat {
        switch mode {
        case .crop_1_1: return 1.0
        case .crop_4_3: return 4.0 / 3.0
        case .crop_16_9: return 16.0 / 9.0
        default: return 1.0
        }
    }

    // MARK: Save Final Image
    func saveFinalImage() {
        guard let finalImage = applyGrayscale(to: selectedImage ?? UIImage(), amount: grayscaleAmount) else { return }

        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
        showSaveAlert = true
    }
}

// MARK: Crop Overlay
struct CropOverlay: Shape {
    let ratio: CGFloat

    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = width / ratio
        let cropRect = CGRect(x: (rect.width - width) / 2,
                              y: (rect.height - height) / 2,
                              width: width,
                              height: height)
        return Path(cropRect)
    }
}

// MARK: Button Style
struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
