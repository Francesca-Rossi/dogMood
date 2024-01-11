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
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                DogListView(viewModel: self.viewModel)
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
            }
            .fullScreenCover(isPresented: $showingAddView)
            {
                AddDogView(viewModel: self.viewModel)
            }
        }
        .navigationViewStyle(.stack)
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DogsListContentView(viewModel: DogViewModel())
    }
}*/
