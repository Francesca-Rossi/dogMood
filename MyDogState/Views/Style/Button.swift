//
//  AnimatedBlueButton.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/10/23.
//

import SwiftUI

struct AnimatedCapsulePurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AnimatedCapsulePurpleButton(configuration: configuration)
    }
    
    struct AnimatedCapsulePurpleButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .padding()
                .background(isEnabled ? Color.customPurple : .gray)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}


struct AnimatedCirclePurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AnimatedCirclePurpleButton(configuration: configuration)
    }
    
    struct AnimatedCirclePurpleButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .padding()
                .background(isEnabled ? Color.customPurple : .gray)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}
