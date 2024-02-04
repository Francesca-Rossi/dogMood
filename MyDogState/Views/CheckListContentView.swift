//
//  CheckListContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 10/01/24.
//

import SwiftUI
import CoreData

struct CheckListContentView: View {
    @EnvironmentObject var checkVM: CheckMoodViewModel
    @State var dogVM: DogViewModel
    @State private var showingAddView = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                if checkVM.isCheckListEmpty
                {
                    addNewCheckButton(isToolbar: false)
                        .buttonStyle(AnimatedCapsuleBlueButtonStyle())
                }
                else
                {
                    CheckListView(viewModel: self.checkVM)
                }
            }
            .navigationTitle("All Check")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    addNewCheckButton(isToolbar: true)
                        .disabled(checkVM.isCheckListEmpty)
                }
            }
            .fullScreenCover(isPresented: $showingAddView)
            {
                let _ = Logger.shared.log("Open add new check view", level: LogLevel.Trace , saveToFile: true)
                SelectableDogListView(viewModel: dogVM)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func addNewCheckButton(isToolbar: Bool) -> some View
    {
        Button
        {
            showingAddView.toggle()
        }label: {
            if isToolbar
            {
                Label("Add new check", systemImage: "plus.circle")
            }
            else
            {
                HStack
                {
                    Image(systemName: "plus.circle.fill")
                    Text("Check mood now")
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


/*#Preview {
    CheckListContentView()
}*/
