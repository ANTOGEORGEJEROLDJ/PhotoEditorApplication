//
//  CoreDataManager.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }
    }

    func saveImage(_ image: UIImage) {
        let context = container.viewContext
        let newItem = EditedPhoto(context: context)
        newItem.id = UUID()
        newItem.date = Date()
        newItem.imageData = image.jpegData(compressionQuality: 1.0)

        do {
            try context.save()
            print("✅ Image saved to Core Data")
        } catch {
            print("❌ Failed to save image: \(error)")
        }
    }

    func fetchImages() -> [UIImage] {
        let request: NSFetchRequest<EditedPhoto> = EditedPhoto.fetchRequest()
        let context = container.viewContext
        do {
            let results = try context.fetch(request)
            return results.compactMap { item in
                guard let data = item.imageData else { return nil }
                return UIImage(data: data)
            }
        } catch {
            print("❌ Failed to fetch images: \(error)")
            return []
        }
    }
}
