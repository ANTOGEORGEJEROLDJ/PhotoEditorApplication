//
//  SaveButtonView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct SaveButtonView: View {
    let image: UIImage
    @State private var isSaved = false

    var body: some View {
        Button(action: {
            CoreDataManager.shared.saveImage(image)
            isSaved = true
        }) {
            Text(isSaved ? "Saved ✔︎" : "Save Image")
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSaved ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.top)
    }
}
//struct SaveButtonView: View {
//    let image: UIImage
//    var onSave: () -> Void
//
//    var body: some View {
//        Button(action: onSave) {
//            Text("Save Changes")
//                .font(.headline)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.purple)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .shadow(radius: 4)
//        }
//        .padding()
//    }
//}
