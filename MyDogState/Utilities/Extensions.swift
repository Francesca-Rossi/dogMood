//
//  Extensions.swift
//  MyDogState
//
//  Created by Francesca Rossi on 15/01/24.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct ValidatableTextField: View {
    let placeholder: String
    @State private var text = ""
    var validation: (String) -> Bool
    
    @Binding private var sourceText: String
    
    init(_ placeholder: String, text: Binding<String>, validation: @escaping (String) -> Bool) {
        self.placeholder = placeholder
        self.validation = validation
        self._sourceText = text
        
        self.text = text.wrappedValue
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .onChange(of: text) { newValue in
                if validation(newValue) {
                    self.sourceText = newValue
                } else {
                    self.text = sourceText
                }
            }
    }
}
