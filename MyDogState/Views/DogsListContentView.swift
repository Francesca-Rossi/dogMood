//
//  ContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI
import CoreData

struct DogsListContentView: View {
    @EnvironmentObject var viewModel: DogViewModel
    @State private var showingAddView = false
    @State var selectedItem: Dog?
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                if viewModel.isDogListEmpty
                {
                    addNewDogButton(isToolbar: false)
                        .buttonStyle(AnimatedCapsuleBlueButtonStyle())
                }
                else
                {
                    dogList
                }
            }
            .navigationTitle("My Dog List")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    addNewDogButton(isToolbar: true)
                        .disabled(viewModel.isDogListEmpty)
                }
            }
            .fullScreenCover(isPresented: $showingAddView)
            {
                AddDogView(viewModel: self.viewModel)
            }
            .fullScreenCover(item: $selectedItem)
            {
                item in
                DogDetailView( dog: item)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    var dogList: some View
    {
        List{
            ForEach(viewModel.dogsList)
            {
                dog in
                //TODO: e' necessario fare vedere l'img?
                if let imageData = dog.image
                {
                    ItemCellView(
                        image: UIImage(data: imageData),
                        title: dog.name,
                        chipFields: dog.getSexChip(),
                        firstLabel: dog.microchip,
                        secondLabel: dog.formatedDateOfBirthday(),
                        parentViewType: .dogs
                    )
                    .onTapGesture
                    {
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
            .refreshable {
                Task
                {
                    var info = ErrorInfo()
                    await viewModel.getAllDogs(info: &info)}
            }
    }
    
    func addNewDogButton(isToolbar: Bool) -> some View
    {
        Button
        {
            showingAddView.toggle()
        }label: {
            if isToolbar
            {
                Label("Add new dog", systemImage: "plus.circle")
            }
            else
            {
                HStack
                {
                    Image(systemName: "plus.circle.fill")
                    Text("Add your first dog")
                }
            }
        }
    }
    
    
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DogsListContentView(viewModel: DogViewModel())
    }
}*/
