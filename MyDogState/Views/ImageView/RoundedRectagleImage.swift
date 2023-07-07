//
//  RoundedRectagleImage.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import SwiftUI

struct RoundedRectagleImage: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .frame(width: 125, height: 125)
            .background(Color.black.opacity(0.2))
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30.0, height: 30.0)))
    }
}

/*struct RoundedRectagleImage_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectagleImage()
    }
}*/
struct RoundedRectagleImageExample: View {
    private var image = UIImage()
    
    var body: some View {
        RoundedRectagleImage(image: image)
    }
}

#if DEBUG
struct RoundedRectagleImageExample_Previews : PreviewProvider {
    static var previews: some View {
        RoundedRectagleImageExample()
    }
}
#endif
