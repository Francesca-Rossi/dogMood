//
//  SelectableDogListView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import SwiftUI

struct SelectableDogListView: View {
    @StateObject var viewModel: DogViewModel
    @Binding var image: UIImage?
    @State var selectedItem: Dog?
    @State private var showActionSheet: Bool = false

    var isSelectable: Bool?
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(viewModel.dogsList)
                    {
                        dog in
                        SelectableRowDogCellView(dog: dog, selectedItem: $selectedItem)
                                .listRowInsets(EdgeInsets()).onTapGesture {
                                    self.selectedItem = dog
                                }
                    }
                }.listStyle(PlainListStyle())
                    .refreshable { viewModel.getAllDogs()
                    }
                //aggiungi il bottone
                Button(action: {self.showActionSheet.toggle()})
                {
                    HStack
                    {
                        Image(systemName: "camera")
                        Text("Check emotional state")
                    }
                }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
                    .fullScreenCover(isPresented: $showActionSheet)
                    {
                        if let dog = selectedItem
                        {
                            CheckEmotionalDogStateContentView(selectedDog: dog)
                        }
                    }
                    //.actionSheet(isPresented: $showActionSheet, content: getActionSheet)
                    //.alert("Camera is not accessible", isPresented: $showErrorMessage) {
                   //     Button("OK", role: .cancel) { }
                   // }
            }/*.sheet(isPresented: $shouldPresentImagePicker)
            {
                ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, selectedImage: self.$image)
            }*/
        }
    }
    
    
}

struct SelectableDogListViewExample: View {
    let errorInfo = ErrorInfo()
    var viewModel = DogViewModel()
    var body: some View {
        DogListView(viewModel: viewModel)
    }
}

#if DEBUG
struct SelectableDogListViewExample_Previews: PreviewProvider {
    static var previews: some View {
        DogListViewExample()
    }
}
#endif

/*struct ListView_Previews: PreviewProvider {
 static var previews: some View {
 DogListView()
 }
 }*/

