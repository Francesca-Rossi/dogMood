//
//  AddDogView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

struct AddDogView: View {
    @StateObject var viewModel: DogViewModel
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
                TextField("Microchip number", text: $microchip).disableAutocorrection(true)
                TextField("name", text: $name).disableAutocorrection(true)
                DatePicker("Date of birth", selection: $dateOfBirth)
                SexView(sex: $sex) //Controlla che funzioni, e che lo passi correttamente al DB
                TextField("Breed", text: $breed).disableAutocorrection(true)
                TextField("Hair Color", text: $hairColor).disableAutocorrection(true)
                HStack
                {
                    Spacer()
                    Button("Add dog")
                    {
                        if let data =  try? ImageUtilities(image: image).convertImageToData(error: &info)
                        {
                            viewModel.addNewDog(microchip: microchip, name: name, dateOfBirth: dateOfBirth, image: data, sex: sex, breed: breed, hairColor: hairColor)
                            dismiss()
                        }
                        else if info.hasErrorInfo()
                        {
                            //TODO controllare che funzioni
                            Alert(
                                title: Text("Error"),
                                message: Text(info.getErrorMessage()),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .disabled(image.size.width == 0 || microchip.isEmpty || name.isEmpty)
                    Spacer()
                }
            }
        }
    }
}

/*struct AddDogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDogView()
    }
}*/
