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
                            ItemCellView(image: UIImage(data: imageData) ?? UIImage(), title: dog.name, chipFields: Chip(title: dog.sex ?? StringUtilities.emptyString, titleColor: dog.getSexForegroundColor(), bgColor: dog.getSexBackgroundColor()), subtitle: dog.microchip, description: DateFormatter().string(for: dog.dateOfBirth), parentViewType: .dogs)
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
                //MARK: - Main bottom menu
                CustomBottomMenuView(viewModel: viewModel, checkViewModel: CheckMoodViewModel())
            }
        }
        .fullScreenCover(item: $selectedItem)
        {
            item in
            DogDetailView( dog: item)
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
