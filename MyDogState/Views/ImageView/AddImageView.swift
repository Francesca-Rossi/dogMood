//
//  ImageView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

struct AddImageView: View {
    @Binding var image: UIImage
    @State private var showSheet = false
    var body: some View {
        HStack {
            CircleImage(image: image)
            ChipView(title: "Change photo", bgColor: .blue)
                .onTapGesture {
                    showSheet = true
                }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showSheet) {
            // Pick an image from the photo library:
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            
            //  If you wish to take a photo from camera instead:
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                ImagePicker(sourceType: .camera, selectedImage: self.$image)
            }
        }
    }
}

/*struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView()
    }
}*/
