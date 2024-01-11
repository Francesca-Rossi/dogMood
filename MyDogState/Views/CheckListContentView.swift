//
//  MoodListContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 10/01/24.
//

import SwiftUI
import CoreData

struct CheckListContentView: View {
    @EnvironmentObject var viewModel: CheckMoodViewModel
    @State private var showingAddView = false
    //@State private var showingAddView = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                CheckListView(viewModel: self.viewModel)
            }
            .navigationTitle("All Check")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button
                    {
                        showingAddView.toggle()
                    } label: {
                        Label("Add new check", systemImage: "plus.circle")
                    }
                }
            }
            .fullScreenCover(isPresented: $showingAddView)
            {
                let _ = Logger.shared.log("Open add new check view", level: LogLevel.Trace , saveToFile: true)
                SelectableDogListView(viewModel: DogViewModel())
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


#Preview {
    CheckListContentView()
}
