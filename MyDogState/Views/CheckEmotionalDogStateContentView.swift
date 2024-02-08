//
//  CheckEmotionalDogStateContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import SwiftUI
struct CheckEmotionalDogStateContentView: View {
    @State var selectedDog: Dog
    @StateObject var viewModel: CheckMoodViewModel
    @StateObject var classificationServiceViewModel = ClassificationsViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var note = ""
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentCamera = false
    @State private var showErrorMessage = false
    @State private var onContinueTap = false
    @State private var goBackHome = false
    @State private var isAllOk = false
    @State private var showError = false
    @State var showLoading = false
    
    
    var body: some View {
        NavigationView {
            VStack
            {
                if let image = classificationServiceViewModel.importedImage 
                {
                    ZStack
                    {
                        VStack(alignment: .center, spacing: 5)
                        {
                            if let dogName = selectedDog.name
                            {
                                Text(dogName)
                                    .font(.title)
                                    .bold()
                            }
                            checkImage(image: image)
                            ScrollView
                            {
                                EmotionalResultDialogView(predictionResult: classificationServiceViewModel.classifications)
                            }.frame(maxWidth: .infinity, maxHeight: 250.0)
                            
                            HStack
                            {
                                checkAgainButton
                                continueButton
                                    .alert("Save new mood", isPresented: $onContinueTap) {
                                        TextField("Add a note", text: $note, axis: .vertical)
                                            .disableAutocorrection(true)
                                        Button("Cancel") {onContinueTap.toggle()}
                                        Button("OK", action: saveCheckAction)
                                    }
                                    .alert("Error to register the check", isPresented: $showError) {
                                        Button("OK") { dismiss() }
                                    }
                                    .fullScreenCover(isPresented: $isAllOk)
                                {
                                    ContentView()
                                }
                            }
                        }.blur(radius: showLoading ? 5 : 0)
                        if showLoading
                        {
                            CustomProgressView(title: "Saving")
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
                    Text("Check emotional status")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.darkPurple)
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
        }.buttonStyle(AnimatedCapsulePurpleButtonStyle())
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
        }.buttonStyle(AnimatedCapsulePurpleButtonStyle())
    }
    
    var pickAnImageButton: some View
    {
        Button {
            classificationServiceViewModel.displayImagePicker.toggle()
        } label: {
            Text("Pick an image")
        }.frame(width: 500.0)
        .buttonStyle(AnimatedCapsulePurpleButtonStyle())
        
    }
    
    func saveCheckAction()
    {
        Task
        {
            var info = ErrorInfo()
            showLoading = true
            if let image = classificationServiceViewModel.importedImage
            {
                info =  await viewModel.addNewEmotionalCheck(note: note, dog: selectedDog, image: image, predictionList: classificationServiceViewModel.classifications)
            }
            else
            {
                info.setErrorMessage(value: "Not check image setted")
                //TODO: registra nel file di log
            }
            if info.isAllOK()
            {
                showError = false
                isAllOk = true
                showLoading = false
            }
            else
            {
                showError = true
                isAllOk = false
                showLoading = false
            }
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

