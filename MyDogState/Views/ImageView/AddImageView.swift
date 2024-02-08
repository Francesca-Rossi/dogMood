//
//  ImageView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

struct AddImageView: View
{
    @Binding var image: UIImage?
    var parentView: ViewParentType
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldPresentCamera = false
    @State private var showErrorMessage = false
    
    var body: some View {
        VStack (spacing: 5)
        {
            if image != nil
            {
                switch parentView
                {
                case .dogs:
                    CircleImage(image: image)
                        .onTapGesture {
                            self.shouldPresentActionSheet = true
                        }
                case .states:
                    RoundedRectagleImage(image: image, width: CGFloat(200.0), height: CGFloat(200.0))
                        .onTapGesture {
                            self.shouldPresentActionSheet = true
                        }
                }
            }
            else
            {
                Image(systemName: "photo.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.darkPurple)
                pickAnImageButton
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
    
    var pickAnImageButton: some View
    {
        Button {
            self.shouldPresentActionSheet = true
        } label: {
            Text("Pick an image")
                .minimumScaleFactor(0.5)
        }.frame(width: 500.0)
            .buttonStyle(AnimatedCapsulePurpleButtonStyle())
    }
    
    func getActionSheet() -> ActionSheet
    {
        return ChoicePhotosSourceActionSheet(showActionSheet: $shouldPresentActionSheet,shouldPresentImagePicker: $shouldPresentImagePicker, shouldPresentCamera: $shouldPresentCamera, showErrorMessage: $showErrorMessage).getActionSheet()
    }
}

/*struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView()
    }
}*/
