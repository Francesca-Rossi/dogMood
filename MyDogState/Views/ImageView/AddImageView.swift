//
//  ImageView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

struct AddImageView: View {
    @Binding var image: UIImage
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldPresentCamera = false
    @State private var showErrorMessage = false
    
    var body: some View {
        HStack {
            CircleImage(image: image)
            ChipView(chip:(title: "Change photo", bgColor: .blue))
                .onTapGesture {
                    self.shouldPresentActionSheet = true
                }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $shouldPresentImagePicker)
        {
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, selectedImage: self.$image)
        }
        .actionSheet(isPresented: $shouldPresentActionSheet, content: getActionSheet )
        .alert("Camera is not accessible", isPresented: $showErrorMessage) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func getActionSheet() -> ActionSheet
    {
        ChoicePhotosSourceActionSheet(showActionSheet: $shouldPresentActionSheet,shouldPresentImagePicker: $shouldPresentImagePicker, shouldPresentCamera: $shouldPresentCamera, showErrorMessage: $showErrorMessage).getActionSheet()
    }
}

/*struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView()
    }
}*/
