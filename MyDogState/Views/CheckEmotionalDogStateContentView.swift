//
//  CheckEmotionalDogStateContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import SwiftUI
struct CheckEmotionalDogStateContentView: View {
    @StateObject var dogViewModel: DogViewModel
    @StateObject var classificationServiceViewModel = CheckEmotionalDogStateContentViewModel()
    
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
                        List(classificationServiceViewModel.classifications)
                        {
                            Text($0.toString())
                            .bold()
                            .padding()
                        }.frame(minHeight: CGFloat(300.0))
                        //Text(classificationServiceViewModel.classifications)
                            
                    }
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
        .sheet(isPresented: $classificationServiceViewModel.displayImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $classificationServiceViewModel.importedImage)
        }
    }
}

#if DEBUG
struct CheckEmotionalDogStateContentView_example: PreviewProvider {
    static var previews: some View {
        CheckEmotionalDogStateContentView(dogViewModel: DogViewModel())
    }
}
#endif

