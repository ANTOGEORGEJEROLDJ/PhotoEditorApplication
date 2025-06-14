//
//  DrawingOverlay.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

struct DrawingOverlay: View {
    @Binding var path: Path
    @State private var lastPoint: CGPoint?

    var body: some View {
        GeometryReader { geo in
            Path { p in
                p.addPath(path)
            }
            .stroke(Color.red.opacity(0.7), lineWidth: 3)

            Color.clear
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if let last = lastPoint {
                            path.addLine(to: value.location)
                        } else {
                            path.move(to: value.location)
                        }
                        lastPoint = value.location
                    }
                    .onEnded { _ in
                        lastPoint = nil
                    }
                )
        }
    }
}
