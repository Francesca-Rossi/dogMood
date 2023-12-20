//
//  AnimatedBlueButton.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/10/23.
//

import SwiftUI

struct AnimatedCapsuleBlueButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AnimatedCapsuleBlueButton(configuration: configuration)
    }
    
    struct AnimatedCapsuleBlueButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .padding()
                .background(isEnabled ? .blue : .gray)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}


struct AnimatedCircleBlueButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AnimatedCircleBlueButton(configuration: configuration)
    }
    
    struct AnimatedCircleBlueButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .padding()
                .background(isEnabled ? .blue : .gray)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}
