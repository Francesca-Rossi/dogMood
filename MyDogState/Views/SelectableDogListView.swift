//
//  SelectableDogListView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import SwiftUI

struct SelectableDogListView: View {
    @StateObject var viewModel: DogViewModel
    @State var selectedItem: Dog?
    @Environment(\.dismiss) var dismiss
    @State private var showActionSheet: Bool = false

    //TODO: remove this
    //var isSelectable: Bool?
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(viewModel.dogsList)
                    {
                        dog in
                        SelectableRowDogCellView(dog: dog, selectedItem: $selectedItem)
                           .onTapGesture {
                                self.selectedItem = dog
                            }
                    }
                }.listStyle(PlainListStyle())
                    .refreshable { Task {
                        var info = ErrorInfo()
                        await viewModel.getAllDogs(info: &info)}
                    }
                //aggiungi il bottone
                Button(action: {self.showActionSheet.toggle()})
                {
                    HStack
                    {
                        Image(systemName: "camera")
                        Text("Check emotional state")
                    }
                }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
                .fullScreenCover(isPresented: $showActionSheet)
                {
                    if let dog = selectedItem
                    {
                        CheckEmotionalDogStateContentView(selectedDog: dog, viewModel: CheckMoodViewModel(readMode: false))
                    }
                }
                .disabled(buttonIsDisabled())
            }
            .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .principal){
                        Text("Select a dog")
                            .font(.title)
                            .bold()
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        Button
                        {
                            dismiss()
                        } label: {
                            Label("Go back", systemImage: "chevron.left")
                        }
                    }}
        }.navigationViewStyle(.stack)
    }
    
    func buttonIsDisabled()-> Bool
    {
        if selectedItem == nil
        {
            return true
        }
        return false
    }
    
}

/*struct SelectableDogListViewExample: View {
    let errorInfo = ErrorInfo()
    var viewModel = DogViewModel()
    var body: some View {
        DogListView(viewModel: viewModel)
    }
}*/

/*#if DEBUG
struct SelectableDogListViewExample_Previews: PreviewProvider {
    static var previews: some View {
        DogListViewExample()
    }
}
#endif*/

/*struct ListView_Previews: PreviewProvider {
 static var previews: some View {
 DogListView()
 }
 }*/

