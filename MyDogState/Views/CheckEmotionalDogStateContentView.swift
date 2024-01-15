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
                if let image = classificationServiceViewModel.importedImage {
                    VStack(alignment: .center) {
                        RoundedRectagleImage(image: image, width: CGFloat(200.0), height: CGFloat(200.0))
                            .onTapGesture {
                                classificationServiceViewModel.displayImagePicker.toggle()
                            }
                        
                        ScrollView {
                            EmotionalResultDialogView(predictionResult: classificationServiceViewModel.classifications)
                        }
                        Button(action: { onContinueTap = true})
                        {
                            //TODO: 07/01
                            HStack
                            {
                                Image(systemName: "continue")
                                Text("Continue")
                            }
                        }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
                            .fullScreenCover(isPresented: $onContinueTap, content:
                                                {
                                if let importedImage = classificationServiceViewModel.importedImage
                                {
                                    ResultDogMoodContentView(viewModel: CheckMoodViewModel(), dog: selectedDog, image: image, resultList: classificationServiceViewModel.classifications)
                                }
                            })
                        Button(action: {classificationServiceViewModel.importedImage = nil })
                        {
                            HStack
                            {
                                Image(systemName: "camera")
                                Text("Check again")
                            }
                        }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
                        Button(action: {goBackHome.toggle()})
                        {
                            HStack
                            {
                                Image(systemName: "home")
                                Text("Back home")
                            }
                        }.fullScreenCover(isPresented: $goBackHome)
                        {
                            ContentView()
                        }
                        .buttonStyle(AnimatedCapsuleBlueButtonStyle())
                        
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
            .navigationTitle("Take an image")
            .toolbar{
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

