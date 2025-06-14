//
//  NeonButtonStyle.swift
//  PhotoEditApp
//
//  Created by Paranjothi iOS MacBook Pro on 14/06/25.
//

import SwiftUI

extension View {
    func neonButtonStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [Color.pink, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 4)
    }
}
