//
//  CropImageView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct CropView: View {
    var inputImage: UIImage?
    var image: UIImage?
    @State private var selectedRatio: CGSize = CGSize(width: 1, height: 1)
    @State private var showSaveAlert = false

    var body: some View {
        VStack {
            if let image = image {
                let cropped = cropImage(image, to: selectedRatio)
                Image(uiImage: cropped ?? image)
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

            Button("Save Cropped Image") {
                if let image = image,
                   let cropped = cropImage(image, to: selectedRatio) {
                    UIImageWriteToSavedPhotosAlbum(cropped, nil, nil, nil)
                    showSaveAlert = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .navigationTitle("Crop Image")
        .alert("Image Saved!", isPresented: $showSaveAlert) {
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

