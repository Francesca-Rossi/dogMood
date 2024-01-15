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
                if viewModel.isDogListEmpty
                {
                    addNewDogButton(isToolbar: false)
                        .buttonStyle(AnimatedCapsuleBlueButtonStyle())
                }
                else
                {
                    DogListView(viewModel: self.viewModel)
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
        }
        .navigationViewStyle(.stack)
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
