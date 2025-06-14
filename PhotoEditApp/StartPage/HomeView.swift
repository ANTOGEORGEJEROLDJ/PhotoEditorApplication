//
//  HomeView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct HomeScreen: View {
    
    
    @State private var refreshID = UUID()
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
                .id(refreshID)
            
            ScrollView (.horizontal){
                HStack(spacing: 20) {
                    NavigationLink(destination: BlackWhiteFilterView(viewModel: viewModel)){
                        Text("Black&white")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 30)
                            .bold()
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: CropView(viewModel: viewModel)){
                        Text("Crop")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 30)
                            .bold()
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(15)
                    }
                    NavigationLink( destination: TextOverlayView(viewModel: viewModel)){
                        Text("Text editor")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 30)
                            .bold()
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: SaturationView(viewModel: viewModel)){
                        Text("Saturaction")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 30)
                            .bold()
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: ShadowEffectView(viewModel: viewModel)){
                        Text("Shadow")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 30)
                            .bold()
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: BrightnessView(viewModel: viewModel)){
                        Text("brightness")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 30)
                            .bold()
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(15)
                    }
                }
                .padding()
            }
            
            SaveButtonViews(image: viewModel.editedImage) {
                viewModel.saveToCoreData()
            }
            
            NavigationLink(destination: SavedImagesView()) {
                Text("My Gallery")
                    .padding()
                    .frame(width: 350, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Editor Home")
        .onChange(of: viewModel.editedImage) { _ in
            refreshID = UUID()
        }
    }
}
struct EditButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(width: 90, height: 30)
            .bold()
            .padding()
            .background(Color.blue.opacity(0.7))
            .cornerRadius(15)
    }
}
