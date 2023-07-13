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
    var body: some View {
        NavigationView {
            DogProfileView(dog: dog)
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

/*struct DogPageView_Previews: PreviewProvider {
    static var previews: some View {
        DogContentView()
    }
}*/
