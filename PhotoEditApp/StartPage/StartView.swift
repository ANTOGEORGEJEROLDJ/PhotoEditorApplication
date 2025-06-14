//
//  StartView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI
import PhotosUI

    

    struct StartView: View {
        @State private var selectedImage: UIImage?
        @State private var showPicker = false
        @State private var navigate = false

        var body: some View {
            NavigationView {
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(Text("Select an Image").foregroundColor(.gray))
                    }

                    Button("Select Image") {
                        showPicker = true
                    }
                    .padding()
                    .sheet(isPresented: $showPicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }

                    NavigationLink(destination: HomeScreen(originalImage: selectedImage ?? UIImage()), isActive: $navigate) {
                        EmptyView()
                    }

                    Button("Continue") {
                        if selectedImage != nil { navigate = true }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .navigationTitle("Photo Editor")
            }
        }
    }
