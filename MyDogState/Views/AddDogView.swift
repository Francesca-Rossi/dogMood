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
    @State private var image: UIImage?
    @State private var sex = sexType.Boy
    @State private var dateOfBirth = Date()
    @State private var hairColor = ""
    @State private var breed = ""
    
    var body: some View {
        NavigationView {
            VStack
            {
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
            .onTapGesture {
                hideKeyboard()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("Add New Dog")
                        .font(.title)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button
                    {
                        dismiss()
                    } label: {
                        Label("Go back", systemImage: "chevron.left")
                    }
                }}
        }.navigationViewStyle(.stack)
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
            HStack
            {
                Label("Microchip", systemImage: "cpu")
                ValidatableTextField("Placeholder", text: $microchip, validation: { $0.contains(/[0-9]+$/)})
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    
            }
            HStack
            {
                Label("Dog name", systemImage: "person.crop.square.filled.and.at.rectangle")
                TextField("Name", text: $name).disableAutocorrection(true)
            }
            HStack
            {
                Label("Birthday", systemImage: "birthday.cake.fill")
                DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                    .pickerStyle(.inline)
            }
            SexView(sex: $sex)
        }
    }
    
    var otherInfoSection: some View
    {
        Section (header: Text("Other info").textCase(nil))
        {
            HStack
            {
                Label("Breed", systemImage: "pawprint.fill")
                TextField("Breed", text: $breed).disableAutocorrection(true)
            }
            HStack
            {
                Label("Hair color", systemImage: "eyedropper")
                TextField("Hair color", text: $hairColor).disableAutocorrection(true)
            }
        }
    }
    
    func saveDogAction()
    {
        Task
        {
            if let image = image
            {
                var info = ErrorInfo()
                await viewModel.addNewDog(
                    microchip: microchip,
                    name: name,
                    dateOfBirth: dateOfBirth,
                    image: image,
                    sex: sex,
                    breed: breed,
                    hairColor: hairColor, info: &info)
                if info.hasErrorInfo()
                {
                    //TODO controllare che funzioni
                    Alert(
                        title: Text("Error"),
                        message: Text(info.getErrorMessage()),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            dismiss()
        }
    }
    
    func buttonIsDisabled()-> Bool
    {
        if let image = image
        {
            return image.size.width == 0 || microchip.isEmpty || name.isEmpty
        }
        return true 
    }
}

/*struct AddDogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDogView()
    }
}*/
