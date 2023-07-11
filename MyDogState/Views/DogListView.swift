//
//  ListView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import SwiftUI

struct DogListView: View {
    @StateObject var viewModel: DogViewModel
    var body: some View {
        List{
            ForEach(viewModel.dogsList)
            {
                dog in
                //Controlla questo if..
                if let imageData = dog.image
                {
                    ItemCellView(image: UIImage(data: imageData) ?? UIImage(), title: dog.name, chipFields: (title: dog.sex ?? "", bgColor: dog.getSexColor()), firstLabel: dog.microchip, secondLabel: DateFormatter().string(for: dog.dateOfBirth), parentViewType: .dogs)
                    .listRowInsets(EdgeInsets())
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
            .refreshable {
                await viewModel.getAllDogs()
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
