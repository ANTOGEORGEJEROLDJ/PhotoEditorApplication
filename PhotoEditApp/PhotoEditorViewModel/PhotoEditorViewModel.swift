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

    func updateImage(_ image: UIImage) {
        self.editedImage = image
    }

    func resetToOriginal() {
        self.editedImage = originalImage
    }

    func saveToCoreData() {
        CoreDataManager.shared.saveImage(editedImage)
    }
}
