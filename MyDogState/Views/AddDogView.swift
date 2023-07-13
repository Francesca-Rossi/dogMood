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
        Form{
                Section {
                    AddImageView(image: $image) //TODO: Devo passare l'immagine al database e fare in modo che apra la camera)
                } header: {
                    Text("Profile image").textCase(nil)
                }
                Section {
                    TextField("Microchip number", text: $microchip).disableAutocorrection(true)
                    TextField("name", text: $name).disableAutocorrection(true)
                    DatePicker("Date of birth", selection: $dateOfBirth).pickerStyle(.inline)
                    SexView(sex: $sex)
                }header: {
                    Text("Main info").textCase(nil)
                }
                Section
                {
                    TextField("Breed", text: $breed).disableAutocorrection(true)
                    TextField("Hair Color", text: $hairColor).disableAutocorrection(true)
                }header: {
                    Text("Other info").textCase(nil)
                }
                Section
                {
                    Button("Add dog")
                    {
                        Task
                        {
                            let info =  await viewModel.addNewDog(
                                microchip: microchip,
                                name: name,
                                dateOfBirth: dateOfBirth,
                                image: image,
                                sex: sex,
                                breed: breed,
                                hairColor: hairColor)
                            if info.hasErrorInfo()
                            {
                                //TODO controllare che funzioni
                                Alert(
                                    title: Text("Error"),
                                    message: Text(info.getErrorMessage()),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            dismiss()
                        }
                    }
                    .disabled(image.size.width == 0 || microchip.isEmpty || name.isEmpty)
                }
            }
    }
}

/*struct AddDogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDogView()
    }
}*/
