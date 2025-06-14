//
//  OverlayImageView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct OverlayImageView: View {
    @Binding var overlay: OverlayImage

    @State private var currentDrag: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var currentRotation: Angle = .zero

    var body: some View {
        Image(uiImage: overlay.image)
            .resizable()
            .frame(width: 150, height: 150)
            .scaleEffect(overlay.scale * currentScale)
            .rotationEffect(overlay.rotation + currentRotation)
            .offset(
                CGSize(width: overlay.offset.width + currentDrag.width,
                       height: overlay.offset.height + currentDrag.height)
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        currentDrag = value.translation
                    }
                    .onEnded { value in
                        overlay.offset.width += value.translation.width
                        overlay.offset.height += value.translation.height
                        currentDrag = .zero
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentScale = value
                    }
                    .onEnded { value in
                        overlay.scale *= value
                        currentScale = 1.0
                    }
            )
            .gesture(
                RotationGesture()
                    .onChanged { angle in
                        currentRotation = angle
                    }
                    .onEnded { angle in
                        overlay.rotation += angle
                        currentRotation = .zero
                    }
            )
    }
}
