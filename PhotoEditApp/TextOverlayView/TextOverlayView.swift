//
//  TextOverlayView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct TextOverlayView: View {
    let image: UIImage
    @State private var text = "Edit Me"
    @State private var textColor = Color.black
    @State private var fontSize: CGFloat = 32

    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()

                Text(text)
                    .font(.system(size: fontSize))
                    .foregroundColor(textColor)
                    .padding()
            }

            TextField("Enter Text", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()

            ColorPicker("Text Color", selection: $textColor)
                .padding()

            Slider(value: $fontSize, in: 10...60) {
                Text("Font Size")
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Text & Color")
        .padding()
    }
}
