//
//  AnimatedBlueButton.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/10/23.
//

import SwiftUI

struct AnimatedCapsuleBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
