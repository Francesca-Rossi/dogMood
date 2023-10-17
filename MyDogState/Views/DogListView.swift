//
//  ListView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import SwiftUI

struct DogListView: View {
    @StateObject var viewModel: DogViewModel
    @State var selectedItem: Dog?
    @State private var openCheckStateVC = false
    var body: some View {
        NavigationView {
            VStack
            {
                List{
                    ForEach(viewModel.dogsList)
                    {
                        dog in
                        //Controlla questo if..
                        if let imageData = dog.image
                        {
                            DogCellView(image: UIImage(data: imageData) ?? UIImage(), title: dog.name, chipFields: (title: dog.sex ?? "", bgColor: dog.getSexColor()), firstLabel: dog.microchip, secondLabel: DateFormatter().string(for: dog.dateOfBirth), parentViewType: .dogs)
                                .listRowInsets(EdgeInsets()).onTapGesture {
                                    self.selectedItem = dog
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
                /*Button("CHECK STATE") {
                    openCheckStateVC.toggle()
                }
                .buttonStyle(AnimatedCapsuleBlueButton())
                .sheet(isPresented: $openCheckStateVC)
                {
                    SelectableDogListView(viewModel: viewModel)
                }*/
                CustomBottomMenuView(viewModel: viewModel)
            }
        }
        .fullScreenCover(item: $selectedItem)
        {
            item in
            DogDetailView(dog: item)
        }
    }
}

struct DogListViewExample: View {
    let errorInfo = ErrorInfo()
    var viewModel = DogViewModel()
    var body: some View {
        DogListView(viewModel: viewModel)
    }
}

#if DEBUG
struct DogListViewExample_Previews: PreviewProvider {
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
