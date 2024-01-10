//
//  DogPageView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 13/07/23.
//

import SwiftUI

struct DogDetailView: View {
    var dog: Dog
    @Environment(\.dismiss) var dismiss
    var list = ["First Row", "First Row", "First Row"]
    var body: some View {
        NavigationView {
            VStack
            {
                DogProfileView(dog: dog)
                let list = dog.getBestMoodList()
                
                ScrollView (.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(0...(list.count-1), id: \.self) { index in
                            DogDetailCard(bestMood: list[index])
                        }
                    }
                }.frame(height: 300)
               
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
