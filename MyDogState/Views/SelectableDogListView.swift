//
//  SelectableDogListView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import SwiftUI

struct SelectableDogListView: View {
    @StateObject var viewModel: DogViewModel
    @State var selectedItem: Dog?
    @State var isSelected: Bool?
    var isSelectable: Bool?
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(viewModel.dogsList)
                    {
                        dog in
                        //Controlla questo if..
                        if let imageData = dog.image
                        {
                            DogCellView(image: UIImage(data: imageData) ?? UIImage(), title: dog.name, chipFields: (title: dog.sex ?? "", bgColor: dog.getSexColor()), firstLabel: dog.microchip, secondLabel: DateFormatter().string(for: dog.dateOfBirth), parentViewType: .dogs, isSelected: $isSelected.wrappedValue, isSelectable: true)
                                .listRowInsets(EdgeInsets()).onTapGesture {
                                    self.selectedItem = dog
                                    self.isSelected = !(self.isSelected ?? false)
                                }
                        }
                        
                    }
                    .onDelete{
                        indexSet in
                        Task
                        {
                            await viewModel.deleteDog(offset: indexSet)
                        }
                    }
                }.listStyle(PlainListStyle())
                    .refreshable { viewModel.getAllDogs()
                    }
                //aggiungi il bottone
                    Button("Press Me") {
                        print("Button pressed!")
                    }
                    .buttonStyle(AnimatedCapsuleBlueButton())
             }
        }

    }
}

func checkState()
{
    
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

