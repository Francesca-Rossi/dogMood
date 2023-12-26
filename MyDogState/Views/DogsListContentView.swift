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
                let _ = Logger.shared.log("Open dog list view", level: LogLevel.Trace , saveToFile: true)
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
            .sheet(isPresented: $showingAddView)
            {
                let _ = Logger.shared.log("Open add new dog view", level: LogLevel.Trace , saveToFile: true)
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
