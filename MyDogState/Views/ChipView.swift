//
//  ChipView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import SwiftUI

struct ChipView: View {
    var title: String
    var bgColor: Color
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            //.background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
            .background(bgColor)
            .cornerRadius(16)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
    }
}

/*struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ChipView()
    }
}*/

struct ChipViewExample : View {
    private var title = "Titolo Chip"
    
    var body: some View {
        ChipView(title: title, bgColor: .blue)
    }
}

#if DEBUG
struct ChipViewExample_Previews : PreviewProvider {
    static var previews: some View {
        ChipViewExample()
    }
}
#endif
