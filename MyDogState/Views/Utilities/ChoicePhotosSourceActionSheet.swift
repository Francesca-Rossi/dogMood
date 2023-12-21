//
//  ChoicePhotosSourceActionSheetChoicePhotosSourceActionSheet.swift
//  MyDogState
//
//  Created by Francesca Rossi on 12/12/23.
//

import SwiftUI

struct ChoicePhotosSourceActionSheet
{
    @Binding var showActionSheet: Bool
    @Binding var shouldPresentImagePicker: Bool 
    @Binding var shouldPresentCamera: Bool
    @Binding var showErrorMessage: Bool
    
    func getActionSheet() -> ActionSheet
    {
        let cameraButton: ActionSheet.Button = .default(Text("Camera"), action: {openCamera()})
        let libraryButton: ActionSheet.Button = .default(Text("Photo Library"), action: {openLibrary()})
        let cancelButton: ActionSheet.Button = .cancel()
        return ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [cameraButton, libraryButton, cancelButton])
    }
    
    private func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            self.shouldPresentImagePicker = true
            self.shouldPresentCamera = true
        }
        else
        {
            self.showErrorMessage = true
        }
    }
    
    private func openLibrary()
    {
        self.shouldPresentImagePicker = true
        self.shouldPresentCamera = false
    }
}


