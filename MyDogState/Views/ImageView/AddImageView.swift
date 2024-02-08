//
//  ImageView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

struct AddImageView: View
{
    private let CHANGE_PHOTO_LABEL = "Change photo"
    
    @Binding var image: UIImage?
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldPresentCamera = false
    @State private var showErrorMessage = false
    
    var body: some View {
        HStack {
           
            CircleImage(image: image)
            ChipView(chip: Chip(title: CHANGE_PHOTO_LABEL, titleColor: .white, bgColor: .customPurple)) 
                .onTapGesture {
                    self.shouldPresentActionSheet = true
                }
    
        }
        .padding(.horizontal, 20)
        .actionSheet(isPresented: $shouldPresentActionSheet, content: getActionSheet )
        .alert("Camera is not accessible", isPresented: $showErrorMessage) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $shouldPresentImagePicker)
        {
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, selectedImage: $image)
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
