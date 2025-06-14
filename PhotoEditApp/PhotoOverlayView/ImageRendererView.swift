//
//  ImageRendererView.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//



import SwiftUI

struct ImageRendererView<Content: View>: UIViewRepresentable {
    let content: Content
    let completion: (UIImage?) -> Void

    init(@ViewBuilder content: () -> Content, completion: @escaping (UIImage?) -> Void) {
        self.content = content()
        self.completion = completion
    }

    func makeUIView(context: Context) -> UIView {
        let controller = UIHostingController(rootView: content)
        let view = controller.view!
        view.backgroundColor = .clear

        DispatchQueue.main.async {
            let targetSize = view.intrinsicContentSize
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let image = renderer.image { _ in
                view.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
            }
            completion(image)
        }

        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
