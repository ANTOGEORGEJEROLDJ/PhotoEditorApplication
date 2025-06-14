//
//  HomeView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct HomeScreen: View {
    let originalImage: UIImage
    @StateObject private var viewModel: PhotoEditorViewModel

    init(originalImage: UIImage) {
        self.originalImage = originalImage
        _viewModel = StateObject(wrappedValue: PhotoEditorViewModel(image: originalImage))
    }

    var body: some View {
        ScrollView {
            Image(uiImage: viewModel.editedImage)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding()

            VStack(spacing: 20) {
                NavigationLink("1. Black & White", destination: BlackWhiteFilterView(viewModel: viewModel))
                NavigationLink("2. Crop Image", destination: CropView(viewModel: viewModel))
                NavigationLink("3. Text & Color Picker", destination: TextOverlayView(viewModel: viewModel))
                NavigationLink("4. Saturation Adjust", destination: SaturationView(viewModel: viewModel))
                NavigationLink("5. Shadow Effect", destination: ShadowEffectView(viewModel: viewModel))
                NavigationLink("6. Brightness Adjust", destination: BrightnessView(viewModel: viewModel))
            }
            .padding()

            SaveButtonViews(image: viewModel.editedImage) {
                viewModel.saveToCoreData()
            }

            NavigationLink(destination: SavedImagesView()) {
                Text("My Gallery")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Editor Home")
    }
}
