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
        ZStack
        {
            RoundedRectangle(cornerRadius: 25)
                .fill(chip.bgColor)
                .frame(minWidth: 100)
                .frame(height: 30)
            
            Text(chip.title)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .font(.headline)
                .foregroundColor(chip.titleColor)
                .padding(.horizontal, 5)
        }
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
