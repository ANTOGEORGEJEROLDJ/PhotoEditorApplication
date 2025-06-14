//
//  CropImageView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct CropView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var selectedRatio: CGSize = CGSize(width: 1, height: 1)
    @State private var showSaveAlert = false

    var body: some View {
        VStack {
            if let cropped = cropImage(viewModel.editedImage, to: selectedRatio) {
                Image(uiImage: cropped)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            HStack {
                Button("1:1") { selectedRatio = CGSize(width: 1, height: 1) }
                Button("4:3") { selectedRatio = CGSize(width: 4, height: 3) }
                Button("16:9") { selectedRatio = CGSize(width: 16, height: 9) }
            }
            .padding()
            .buttonStyle(.borderedProminent)

            Button("Apply Crop") {
                if let cropped = cropImage(viewModel.editedImage, to: selectedRatio) {
                    viewModel.updateImage(cropped)
                    showSaveAlert = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            SaveButtonViews(image: viewModel.editedImage) {
                viewModel.saveToCoreData()
            }

            Spacer()
        }
        .navigationTitle("Crop Image")
        .alert("Cropped Image Applied", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    func cropImage(_ image: UIImage, to ratio: CGSize) -> UIImage? {
        let originalSize = image.size
        let targetWidth = originalSize.width
        let targetHeight = targetWidth * ratio.height / ratio.width

        let originY = (originalSize.height - targetHeight) / 2
        let cropRect = CGRect(x: 0, y: max(0, originY), width: targetWidth, height: targetHeight)

        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
