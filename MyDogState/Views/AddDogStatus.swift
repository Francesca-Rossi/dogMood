//
//  AddDogStatus.swift
//  MyDogState
//
//  Created by Francesca Rossi on 20/12/23.
//

import SwiftUI

struct AddDogStatus: View {
    var image: UIImage
    @State var note: String
    var body: some View {
        VStack
        {
            Text("Page title")
            
            RoundedRectagleImage(image: image)
            Form  {
                Section(header: Text("Note"))
                {
                    
                    TextEditor(text: $note)
                }
            }
            Button(action: {//TODO:
            })
            {
                HStack
                {
                    Image(systemName: "square.and.arrow.down")
                    Text("save in the history")
                }
            }.buttonStyle(AnimatedCapsuleBlueButtonStyle())
        }
    }
}

#Preview {
    AddDogStatus(image: UIImage(), note: "")
}
