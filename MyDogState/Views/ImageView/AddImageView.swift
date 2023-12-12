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
        .actionSheet(isPresented: shouldPresentActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera)
                {
                    self.shouldPresentImagePicker = true
                    self.shouldPresentCamera = true
                }
                else
                {
                    self.showErrorMessage = true
                }
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
            }), ActionSheet.Button.cancel()])
        }.alert("Camera is not accessible", isPresented: $showErrorMessage) {
            Button("OK", role: .cancel) { }
        }
    }
}

/*struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView()
    }
}*/
