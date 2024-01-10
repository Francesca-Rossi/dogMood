//
//  CircleImage.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import SwiftUI

struct CircleImage: View {
    var image: UIImage?
    var width: CGFloat = CGFloat(100)
    var height: CGFloat = CGFloat(100)
    var body: some View {
        Image(uiImage: self.image ?? UIImage())
            .resizable()
            .cornerRadius(50)
            .frame(width: self.width, height: self.height)
            .background(Color.black.opacity(0.2))
            .clipShape(Circle())
    }
}

/*struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}*/

struct CircleImageExample : View {
    private var image = UIImage()
    
    var body: some View {
        CircleImage(image: image)
    }
}

#if DEBUG
struct CircleImageExample_Previews : PreviewProvider {
    static var previews: some View {
        CircleImageExample()
    }
}
#endif

