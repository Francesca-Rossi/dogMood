//
//  CustomProgressView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 03/02/24.
//

import SwiftUI

struct CustomProgressView: View {
    var title: String
    var body: some View {
        ProgressView(title)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
            .padding()
            .frame(width: 120, height: 120, alignment: .center)
            .background(.white)
            .cornerRadius(15)
    }
}

#Preview {
    CustomProgressView(title: "prova")
}
