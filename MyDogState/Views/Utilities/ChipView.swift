//
//  ChipView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import SwiftUI

struct ChipView: View {
    var chip: Chip
    var body: some View {
        Text(chip.title)
            .font(.headline)
            .frame(maxWidth: 300)
            .frame(height: 30)
            .foregroundColor(chip.titleColor)
            .background(chip.bgColor)
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
        ChipView(chip: Chip(title: "Prova", titleColor: .white, bgColor: .blue))
    } 
}

#if DEBUG
struct ChipViewExample_Previews : PreviewProvider {
    static var previews: some View {
        ChipViewExample()
    }
}
#endif
