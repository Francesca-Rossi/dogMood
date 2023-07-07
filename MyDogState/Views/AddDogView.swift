//
//  AddDogView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

struct AddDogView: View {
    @Environment(\.managedObjectContext) var managedObjContex
    @Environment(\.dismiss) var dismiss
    
    @State private var microchip = "" //obbligatorio
    @State private var name = ""
    @State private var image = UIImage()
    @State private var sex = sexType.Boy
    @State private var dateOfBirth = Date()
    @State private var hairColor = ""
    @State private var breed = ""
    
    var body: some View {
        var info = ErrorInfo()
        Form{
            Section {
                AddImageView(image: $image) //TODO: Devo passare l'immagine al database e fare in modo che apra la camera
                TextField("Microchip number", text: $microchip)
                TextField("name", text: $name)
                DatePicker("Date of birth", selection: $dateOfBirth)
                SexView(sex: $sex) //Controlla che funzioni, e che lo passi correttamente al DB
                TextField("Breed", text: $breed)
                TextField("Hair Color", text: $hairColor)
                HStack
                {
                    Spacer()
                    Button("Add dog")
                    {
                        if let data =  try? ImageUtilities(image: image).convertImageToData(error: &info)
                        {
                            DataController().addDog(microchip: microchip, name: name, dateOfBirth: dateOfBirth, image: data, sex: sex, breed: breed, hairColor: hairColor, context: managedObjContex)
                            dismiss()
                        }
                        else if info.hasErrorInfo()
                        {
                            Alert(
                                title: Text("Error"),
                                message: Text(info.getErrorMessage()),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AddDogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDogView()
    }
}
