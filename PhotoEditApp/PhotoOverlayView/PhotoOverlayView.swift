//
//  PhotoOverlayView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct OverlayImage: Identifiable {
    let id = UUID()
    var image: UIImage
    var offset: CGSize = .zero
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
}

struct PhotoOverlayView: View {
    @ObservedObject var viewModel: PhotoEditorViewModel
    @State private var overlays: [OverlayImage] = []
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: viewModel.editedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)

                ForEach($overlays) { $overlay in
                    OverlayImageView(overlay: $overlay)
                }
            }
            .frame(height: 350)
            .clipped()

            HStack {
                Button("Add Photo") {
                    showImagePicker = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Merge & Save") {
                    if let merged = renderOverlayedImage() {
                        viewModel.updateImage(merged)
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if let img = selectedImage {
                        overlays.append(OverlayImage(image: img))
                    }
                }
        }
        .navigationTitle("Add Overlay")
    }

    func renderOverlayedImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: viewModel.editedImage.size)
        return renderer.image { context in
            let baseRect = CGRect(origin: .zero, size: viewModel.editedImage.size)
            viewModel.editedImage.draw(in: baseRect)

            for overlay in overlays {
                let scaleFactor = viewModel.editedImage.size.width / UIScreen.main.bounds.width
                let overlaySize = CGSize(
                    width: overlay.image.size.width * overlay.scale / scaleFactor,
                    height: overlay.image.size.height * overlay.scale / scaleFactor
                )
                let overlayOrigin = CGPoint(
                    x: baseRect.midX + overlay.offset.width * scaleFactor - overlaySize.width / 2,
                    y: baseRect.midY + overlay.offset.height * scaleFactor - overlaySize.height / 2
                )
                let overlayRect = CGRect(origin: overlayOrigin, size: overlaySize)

                context.cgContext.saveGState()
                context.cgContext.translateBy(x: overlayRect.midX, y: overlayRect.midY)
                context.cgContext.rotate(by: CGFloat(overlay.rotation.radians))
                context.cgContext.translateBy(x: -overlayRect.midX, y: -overlayRect.midY)
                overlay.image.draw(in: overlayRect)
                context.cgContext.restoreGState()
            }
        }
    }
}
