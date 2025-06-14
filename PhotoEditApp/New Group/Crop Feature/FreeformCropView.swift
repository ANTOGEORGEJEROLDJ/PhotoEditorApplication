//
//  FreeformCropView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct FreeformCutView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var maskPath = Path()
    @State private var cutoutImage: UIImage?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Group {
                    if let cutout = cutoutImage {
                        Text("Cutout Result")
                            .font(.headline)
                        Image(uiImage: cutout)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    } else if let image = selectedImage {
                        Text("Draw to Cut")
                            .font(.headline)

                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 350)
                                .cornerRadius(12)
                                .shadow(radius: 4)

                            DrawingOverlay(path: $maskPath)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 350)
                            .overlay(Text("No Image Selected").foregroundColor(.gray))
                    }
                }

                // Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        showImagePicker = true
                        cutoutImage = nil
                        maskPath = Path()
                    }) {
                        Label("Select Image", systemImage: "photo")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        if let image = selectedImage {
                            cutoutImage = applyMask(to: image, path: maskPath)
                        }
                    }) {
                        Label("Cut", systemImage: "scissors")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        maskPath = Path()
                    }) {
                        Label("Clear", systemImage: "xmark.circle")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .navigationTitle("Freeform Cut")
        }
    }

    // MARK: - Cutout logic
    func applyMask(to image: UIImage, path: Path) -> UIImage? {
        let imageSize = image.size
        let displayWidth = UIScreen.main.bounds.width - 40 // or use GeometryReader for exact width
        let displayHeight: CGFloat = 350 // This matches the frame height of displayed image

        // Scale factor: display space → image pixel space
        let scaleX = imageSize.width / displayWidth
        let scaleY = imageSize.height / displayHeight

        // Scale the drawn path to match image pixel size
        let scaledPath = path.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))

        let renderer = UIGraphicsImageRenderer(size: imageSize)

        return renderer.image { context in
            let cgContext = context.cgContext

            // Flip context vertically (UIKit’s coordinate system)
            cgContext.translateBy(x: 0, y: imageSize.height)
            cgContext.scaleBy(x: 1, y: -1)

            cgContext.addPath(scaledPath.cgPath)
            cgContext.clip()

            cgContext.draw(image.cgImage!, in: CGRect(origin: .zero, size: imageSize))
        }
    }
}
