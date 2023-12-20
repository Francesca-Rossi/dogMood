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
    
    @State private var microchip = "" //must to have
    @State private var name = "" //must to have
    @State private var image = UIImage() //must to have
    @State private var sex = sexType.Boy
    @State private var dateOfBirth = Date()
    @State private var hairColor = ""
    @State private var breed = ""
    
    var body: some View {
        Form{
            profileImageSection
            mainInfoSection
            otherInfoSection
            }
        Button(action: saveDogAction)
        {
            buttonTitle
        }.disabled(buttonIsDisabled())
        .buttonStyle(AnimatedCapsuleBlueButtonStyle())
    }
    
    var buttonTitle: some View
    {
        HStack
        {
            Image(systemName: "square.and.arrow.down")
            Text("Save new dog")
        }
    }
    
    var profileImageSection: some View
    {
        Section (header: Text("Profile image").textCase(nil))
        {
            AddImageView(image: $image)
        }
    }
    
    var mainInfoSection: some View
    {
        Section (header: Text("Main info").textCase(nil))
        {
            TextField("Microchip number", text: $microchip).disableAutocorrection(true)
            TextField("name", text: $name).disableAutocorrection(true)
            DatePicker("Date of birth", selection: $dateOfBirth).pickerStyle(.inline)
            SexView(sex: $sex)
        }
    }
    
    var otherInfoSection: some View
    {
        Section (header: Text("Other info").textCase(nil))
        {
            TextField("Breed", text: $breed).disableAutocorrection(true)
            TextField("Hair Color", text: $hairColor).disableAutocorrection(true)
        }
    }
    
    func saveDogAction()
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
    
    func buttonIsDisabled()-> Bool
    {
        return image.size.width == 0 || microchip.isEmpty || name.isEmpty
    }
}

/*struct AddDogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDogView()
    }
}*/
