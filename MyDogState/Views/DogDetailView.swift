//
//  DogPageView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 13/07/23.
//

import SwiftUI

struct DogDetailView: View {
    var dog: Dog
    @State var openCheckMoodView = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack
            {
                DogProfileView(dog: dog)
                var list = dog.getBestMoodList()
                if !list.isEmpty
                {
                    ScrollView (.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(0...(list.count-1), id: \.self) { index in
                                DogDetailCard(bestMood: list[index])
                            }
                        }
                    }.frame(height: 300)
                }
                Button(action: {self.openCheckMoodView.toggle()})
                {
                    buttonTitle
                }
                .fullScreenCover(isPresented: $openCheckMoodView)
                {
                    CheckEmotionalDogStateContentView(selectedDog: dog)
                }
                .buttonStyle(AnimatedCapsuleBlueButtonStyle())
            }
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
    
    var buttonTitle: some View
    {
        HStack
        {
            Image(systemName: "camera")
            Text("Check emotional state")
        }
    }
}


/*struct DogPageView_Previews: PreviewProvider {
    static var previews: some View {
        DogContentView()
    }
}*/
