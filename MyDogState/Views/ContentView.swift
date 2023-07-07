//
//  ContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var manageObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var dogs: FetchedResults<Dog>
    @State private var showingAddView = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                List{
                    ForEach(dogs)
                    {
                        dog in
                        //Controlla questo if..
                        if let imageData = dog.image
                        {
                            ItemCellView(image: UIImage(data: imageData) ?? UIImage(), title: dog.name, chipTitle: dog.sex, firstLabel: dog.microchip, secondLabel: DateFormatter().string(for: dog.dateOfBirth), parentViewType: .dogs)
                                .listRowInsets(EdgeInsets())
                        }
                        
                    }
                    .onDelete(perform: deleteDog)
                }.listStyle(PlainListStyle())
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
                AddDogView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteDog(offset: IndexSet)
    {
        withAnimation{
            offset.map{dogs[$0]}.forEach(manageObjContext.delete)
        DataController().save(context: manageObjContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
