//
//  ContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var viewModel: DogViewModel
    @State private var showingAddView = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                List{
                    ForEach(viewModel.dogsList)
                    {
                        dog in
                        //Controlla questo if..
                        if let imageData = dog.image
                        {
                            ItemCellView(image: UIImage(data: imageData) ?? UIImage(), title: dog.name, chipTitle: dog.sex,
                                         chipColor: viewModel.getSexColor(dog.sex ?? ""), firstLabel: dog.microchip, secondLabel: DateFormatter().string(for: dog.dateOfBirth), parentViewType: .dogs)
                                .listRowInsets(EdgeInsets())
                        }
                        
                    }
                    .onDelete{
                        indexSet in
                        withAnimation {
                            viewModel.deleteDog(offset: indexSet)
                        }
                    }
                }.listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.getAllDogs()
                    }
            }
            .navigationTitle("My Dog List")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button
                    {
                        showingAddView.toggle()
                    } label: {
                        Label("Add new dog", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView)
            {
                AddDogView(viewModel: self.viewModel)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    /*private func deleteDog(offset: IndexSet)
    {
        withAnimation{
            offset.map{viewModel.dogsList[$0]}.forEach(manageObjContext.delete)
        DataController().save(context: manageObjContext)
        }
    }*/
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
