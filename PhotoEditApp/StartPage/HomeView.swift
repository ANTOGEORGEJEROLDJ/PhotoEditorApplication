//
//  HomeView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct HomeScreen: View {
    let originalImage: UIImage

    var body: some View {
        ScrollView {
            Image(uiImage: originalImage)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding()

            VStack(spacing: 20) {
                NavigationLink("1. Black & White", destination: BlackWhiteFilterView(image: originalImage))
                NavigationLink("2. Crop Image", destination: CropView(image: originalImage))
                NavigationLink("3. Text & Color Picker", destination: TextOverlayView(image: originalImage))
                NavigationLink("4. Saturation Adjust", destination: SaturationView(image: originalImage))
                NavigationLink("5. Shadow Effect", destination: ShadowEffectView(image: originalImage))
                NavigationLink("6. Brightness Adjust", destination: BrightnessView(image: originalImage))
            }
            .padding()

            SaveButtonView(image: originalImage)
                .padding()
        }
        .navigationTitle("Editor Home")
    }
}
