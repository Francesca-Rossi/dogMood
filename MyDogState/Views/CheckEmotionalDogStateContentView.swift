//
//  CheckEmotionalDogStateContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import SwiftUI



struct CheckEmotionalDogStateContentView: View {
    @StateObject var viewModel = CheckEmotionalDogStateContentViewModel()
    
    var body: some View {
        NavigationView {
            if let image = viewModel.importedImage {
                VStack(alignment: .leading) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .padding()
                        .onTapGesture {
                            viewModel.displayImagePicker.toggle()
                        }
                    
                    ScrollView {
                        Text(viewModel.classifications)
                            .bold()
                            .padding()
                    }
                }
            } else {
                VStack {
                    Image(systemName: "photo.fill")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    
                    Button {
                        viewModel.displayImagePicker.toggle()
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
        .onChange(of: viewModel.importedImage) { _ in viewModel.onChangeImage() }
        .sheet(isPresented: $viewModel.displayImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.importedImage)
        }
    }
}

#if DEBUG
struct CheckEmotionalDogStateContentView_example: PreviewProvider {
    static var previews: some View {
        CheckEmotionalDogStateContentView()
    }
}
#endif

