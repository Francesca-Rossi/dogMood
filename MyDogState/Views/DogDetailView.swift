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
    @State var selectedItem: MoodCheckInfo?
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack
            {
                DogProfileView(dog: dog)
                if let list = dog.emotionalCheckList, !list.isEmpty
                {
                    ScrollView (.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(0...(list.count-1), id: \.self) { index in
                                DogDetailCard(check: list[index])
                                .onTapGesture {
                                    selectedItem = list[index]
                                }
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
                    CheckEmotionalDogStateContentView(selectedDog: dog, viewModel: CheckMoodViewModel(readMode:  false))
                }
                .buttonStyle(AnimatedCapsulePurpleButtonStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .principal){
                        Text("Dog details")
                            .font(.title2)
                            .bold()
                            .minimumScaleFactor(0.5)
                            .foregroundColor(Color.darkPurple)
                    }
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
        .fullScreenCover(item: $selectedItem)
        {
            item in
            CheckDetailView(checkDetail: item)
        }.navigationViewStyle(.stack)
        
        }
    
    var buttonTitle: some View
    {
        HStack
        {
            Image(systemName: "camera")
            Text("Check emotional state")
                .minimumScaleFactor(0.5)
        }
    }
}


/*struct DogPageView_Previews: PreviewProvider {
    static var previews: some View {
        DogContentView()
    }
}*/
