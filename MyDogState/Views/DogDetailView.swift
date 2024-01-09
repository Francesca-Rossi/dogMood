//
//  DogPageView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 13/07/23.
//

import SwiftUI

struct DogDetailView: View {
    @StateObject var viewModel: CheckMoodViewModel
    var dog: Dog
    @Environment(\.dismiss) var dismiss
    var list = ["First Row", "First Row", "First Row"]
    var body: some View {
        NavigationView {
            VStack
            {
                DogProfileView(dog: dog)
  
                List(viewModel.getBestMoodList(dog: dog))
                {
                    //Text(MoodResult.toString(mood: $0.mood))
                    DogDetailCard(bestMood: $0)
                }.frame(minHeight: CGFloat(300.0))
                    .listStyle(PlainListStyle())
                    // 2
                    //LazyHStack {
                    
                    //}
                    //}

                
                
                .navigationTitle("Dog details")
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button
                        {
                            dismiss()
                        } label: {
                            Label("Go back", systemImage: "chevron.left")
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}

/*struct DogPageView_Previews: PreviewProvider {
    static var previews: some View {
        DogContentView()
    }
}*/
