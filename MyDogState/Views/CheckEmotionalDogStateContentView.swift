//
//  CheckEmotionalDogStateContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import SwiftUI
struct CheckEmotionalDogStateContentView: View {
    @State var selectedDog: Dog
    @StateObject var classificationServiceViewModel = ClassificationsViewModel()
    
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentCamera = false
    @State private var showErrorMessage = false
    
    var body: some View {
        NavigationView {
            if let image = classificationServiceViewModel.importedImage {
                VStack(alignment: .leading) {
                    RoundedRectagleImage(image: image, width: CGFloat(200.0), height: CGFloat(200.0))
                        .onTapGesture {
                            classificationServiceViewModel.displayImagePicker.toggle()
                        }
                    
                    ScrollView {
                        var _ = print(classificationServiceViewModel.classifications)
                        EmotionalResultDialogView(predictionResult: classificationServiceViewModel.classifications)
                    }
                    Button(action: {print("continua")})
                    {
                        //TODO: 07/01
                        HStack
                        {
                            Image(systemName: "continue")
                            Text("Continue")
                        }
                    }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
                    Button(action: {classificationServiceViewModel.importedImage = nil })
                    {
                        HStack
                        {
                            Image(systemName: "camera")
                            Text("Check again")
                        }
                    }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
                    Button(action: {print("home")})
                    {
                        //TODO: 07/01
                        HStack
                        {
                            Image(systemName: "home")
                            Text("Back home")
                        }
                    }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
                    
                }
            } else {
                VStack {
                    Image(systemName: "photo.fill")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    
                    Button {
                        classificationServiceViewModel.displayImagePicker.toggle()
                    } label: {
                        Text("Pick an image")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                }
                .padding()
            }
        }
        .onChange(of: classificationServiceViewModel.importedImage) { _ in classificationServiceViewModel.onChangeImage() }
        .actionSheet(isPresented: $classificationServiceViewModel.displayImagePicker, content: getActionSheet)
        .alert("Camera is not accessible", isPresented: $showErrorMessage) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $shouldPresentImagePicker)
        {
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, selectedImage: $classificationServiceViewModel.importedImage)
        }
    }
    
    func getActionSheet() -> ActionSheet
     {
     ChoicePhotosSourceActionSheet(showActionSheet: $classificationServiceViewModel.displayImagePicker,shouldPresentImagePicker: $shouldPresentImagePicker, shouldPresentCamera: $shouldPresentCamera, showErrorMessage: $showErrorMessage).getActionSheet()
     }
}

#if DEBUG
//struct CheckEmotionalDogStateContentView_example: PreviewProvider {
//    static var previews: some View {
        //CheckEmotionalDogStateContentView(selectedDog: Dog())
//    }
//}
#endif

