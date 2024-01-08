//
//  TextWithIcon.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import SwiftUI

struct TextWithIcon: View {
    var icon: String
    var caption: String
    var body: some View {
       HStack
        {
            Image(systemName: icon)
            Text(caption)
        }
    }
}

struct TextWithIconExample: View {
    var iconName = "square.and.pencil"
    var caption = "Name"
    var body: some View {
        HStack
        {
            Image(systemName: iconName)
            Text(caption)
        }
    }
}

#if DEBUG
struct TextWithIconExample_Previews: PreviewProvider {
    static var previews: some View {
        TextWithIconExample()
    }
}
#endif
