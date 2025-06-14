//
//  PhotoEditorViewModel.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

class PhotoEditorViewModel: ObservableObject {
    @Published var originalImage: UIImage
    @Published var editedImage: UIImage

    init(image: UIImage) {
        self.originalImage = image
        self.editedImage = image
    }

    func updateImage(_ newImage: UIImage) {
        DispatchQueue.main.async {
            // Force a new image reference (even if pixels are similar)
            let data = newImage.pngData()
            if let data = data, let forcedImage = UIImage(data: data) {
                self.editedImage = forcedImage
            } else {
                self.editedImage = newImage
            }
        }
    }


    func resetToOriginal() {
        self.editedImage = originalImage
    }

    func saveToCoreData() {
        CoreDataManager.shared.saveImage(editedImage)
    }
}
