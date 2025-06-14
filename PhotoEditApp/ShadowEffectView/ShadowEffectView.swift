//
//  ShadowEffectView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct ShadowEffectView: View {
    let image: UIImage
    @State private var radius: CGFloat = 5
    @State private var offset: CGSize = CGSize(width: 5, height: 5)
    @State private var color: Color = .black

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .shadow(color: color, radius: radius, x: offset.width, y: offset.height)
                .frame(height: 300)

            ColorPicker("Shadow Color", selection: $color)
                .padding()

            Slider(value: $radius, in: 0...20) {
                Text("Radius")
            }
            .padding()

            HStack {
                Text("Offset X")
                Slider(value: $offset.width, in: -20...20)
            }.padding()

            HStack {
                Text("Offset Y")
                Slider(value: $offset.height, in: -20...20)
            }.padding()

            Spacer()
        }
        .navigationTitle("Shadow Effect")
        .padding()
    }
}
