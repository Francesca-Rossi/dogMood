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
    @Environment(\.dismiss) var dismiss
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentCamera = false
    @State private var showErrorMessage = false
    @State private var onContinueTap = false
    @State private var goBackHome = false
    
    
    var body: some View {
        NavigationView {
            VStack
            {
                if let image = classificationServiceViewModel.importedImage 
                {
                    VStack(alignment: .center)
                    {
                        checkImage(image: image)
                        ScrollView
                        {
                            EmotionalResultDialogView(predictionResult: classificationServiceViewModel.classifications)
                        }.frame(maxWidth: .infinity, maxHeight: 250.0)
                        
                        HStack
                        {
                            checkAgainButton
                            continueButton
                            .fullScreenCover(isPresented: $onContinueTap, content:
                            {
                                if let importedImage = classificationServiceViewModel.importedImage
                                {
                                    ResultDogMoodContentView(viewModel: CheckMoodViewModel(), dog: selectedDog, image: importedImage, resultList: classificationServiceViewModel.classifications)
                                }
                            })
                        }
                    }
                } 
                else
                {
                    VStack {
                        Image(systemName: "photo.fill")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        pickAnImageButton
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("Check emotional status").font(.headline)
                        .foregroundColor(Color.blue)
                }
                ToolbarItem(placement: .navigationBarLeading){
                Button
                {
                    dismiss()
                } label: {
                    Label("Go back", systemImage: "chevron.left")
                }
            }}
        }
        .navigationViewStyle(.stack)
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
    
    func checkImage(image: UIImage) -> some View
    {
        RoundedRectagleImage(image: image, width: CGFloat(200.0), height: CGFloat(200.0))
            .onTapGesture {
                classificationServiceViewModel.displayImagePicker.toggle()
            }
    }

    var continueButton: some View
    {
        Button
        {
            onContinueTap.toggle()
        }label: {
            HStack
            {
                Image(systemName: "arrow.right.circle.fill")
                Text("Continue")
            }
        }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
    }
    
    var checkAgainButton: some View
    {
        Button
        {
            classificationServiceViewModel.importedImage = nil
        }label: {
            HStack
            {
                Image(systemName: "camera")
                Text("Check again")
            }
        }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
    }
    
    var pickAnImageButton: some View
    {
        Button {
            classificationServiceViewModel.displayImagePicker.toggle()
        } label: {
            Text("Pick an image")
        }.frame(width: 500.0)
        .buttonStyle(AnimatedCapsuleBlueButtonStyle())
        
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

