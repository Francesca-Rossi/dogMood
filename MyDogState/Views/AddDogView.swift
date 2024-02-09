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
    @State var showLoading = false
    @State private var isAllOk = false
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            ZStack
            {
                mainContent
                if showLoading
                {
                    CustomProgressView(title: "Saving")
                }
            }
        }.navigationViewStyle(.stack)
    }
    
    var mainContent: some View
    {
        VStack
        {
            Form{
                profileImageSection
                mainInfoSection
                otherInfoSection
            }
            Button(action: saveDogAction)
            {
                saveDogButtoTitle
            }.disabled(buttonIsDisabled())
            .buttonStyle(AnimatedCapsulePurpleButtonStyle())
            .alert("Error to save new dog", isPresented: $showError) {
                Button("OK") { dismiss() }
            }
            .fullScreenCover(isPresented: $isAllOk)
            {
                ContentView()
            }
        }
        .blur(radius: showLoading ? 5 : 0)
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .principal){
                Text("Add new dog")
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
            }}
    }
    
    var saveDogButtoTitle: some View
    {
        HStack
        {
            Image(systemName: "square.and.arrow.down")
            Text("Save new dog")
                .minimumScaleFactor(0.5)
        }
    }
    
    var profileImageSection: some View
    {
        Section (header: Text("Profile image").textCase(nil).minimumScaleFactor(0.5))
        {
            AddImageView(image: $image, parentView: .dogs)
        }
    }
    
    var mainInfoSection: some View
    {
        Section (header: Text("Main info").textCase(nil).minimumScaleFactor(0.5))
        {
            HStack
            {
                Label("Microchip", systemImage: "cpu")
                ValidatableTextField("Inser a number", text: $microchip, validation: { $0.contains(/[0-9]+$/)})
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
                DatePicker("", 
                           selection: $dateOfBirth,
                           in: ...Date(),
                           displayedComponents: .date)
                    .pickerStyle(.inline)
            }
            SexView(sex: $sex)
        }
    }
    
    var otherInfoSection: some View
    {
        Section (header: Text("Other info").textCase(nil).minimumScaleFactor(0.5))
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
            var info = ErrorInfo()
            if let image = image
            {
                
                showLoading = true
                await viewModel.addNewDog(
                    microchip: microchip,
                    name: name,
                    dateOfBirth: dateOfBirth,
                    image: image,
                    sex: sex,
                    breed: breed,
                    hairColor: hairColor, info: &info)
            }
            else
            {
                info.setErrorMessage(value: "Not check image setted")
                //TODO: registra nel file di log
            }
            if info.isAllOK()
            {
                showError = false
                isAllOk = true
                showLoading = false
            }
            else
            {
                showError = true
                isAllOk = false
                showLoading = false
                //TODO: registra nel file di log
            }
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
