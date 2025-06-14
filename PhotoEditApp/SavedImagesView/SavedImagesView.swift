//
//  SavedImagesView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct SavedImagesView: View {
    @State private var savedImages: [UIImage] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(savedImages.indices, id: \.self) { index in
                        Image(uiImage: savedImages[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 160)
                            .clipped()
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("My Gallery")
            .onAppear {
                savedImages = CoreDataManager.shared.fetchImages()
            }
        }
    }
}
