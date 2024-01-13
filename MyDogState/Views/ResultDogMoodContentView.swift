//
//  ClassificationDogMoodContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 08/01/24.
//

import SwiftUI

/***
 View that contains the mood form:
 - Dog name
 - DateTime
 - Check Image
 - Mood
 - Check note
 ***/
struct ResultDogMoodContentView: View {
    @StateObject var viewModel: CheckMoodViewModel
    @Environment(\.dismiss) var dismiss
    
    //TODO: per ora gli passo tutto poi decido
    @State public var dog: Dog
    @State public var image: UIImage
    @State private var date = Date()
    @State private var note: String = StringUtilities.emptyString
    public var resultList: [PredictionResult]
    @State private var isAllOk = false
    @State private var showError = false
    @State var showLoading = false
    
    var body: some View {
        var dogName = dog.name ?? StringUtilities.emptyString
    
        NavigationView
        {
            VStack
            {
                Form
                {
                    dogImageSection
                    dogInfoSection
                    mainInfoSection
                    otherInfoSection
                }
                Button(action: saveCheckAction)
                {
                    saveButtonTitle
                }.disabled(buttonIsDisabled())
                .buttonStyle(AnimatedCapsuleBlueButtonStyle())
                .alert("Error to register the check", isPresented: $showError) {
                    Button("OK") { dismiss() }
                }
                .alert("Saving...", isPresented: $showLoading) {
                    Button("OK") { dismiss() }
                }
                .fullScreenCover(isPresented: $isAllOk)
                {
                    ContentView()
                }
            }
            .navigationTitle("Save new \(dogName) mood")
            .toolbar{
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
    
    var saveButtonTitle: some View
    {
        HStack
        {
            Image(systemName: "square.and.arrow.down")
            Text("Save new mood")
        }
    }
    var dogImageSection: some View
    {
        VStack(alignment: .center)
        {
            Section (header: Text("Check photo").textCase(nil))
            {
                
                RoundedRectagleImage(image: image, width: CGFloat(100.0), height: CGFloat(100.0))
                
            }
        }
    }
    
    var dogInfoSection: some View
    {
        Section (header: Text("Dog Info").textCase(nil))
        {
            HStack
            {
                VStack
                {
                    Text("Name")
                    Text(dog.name ?? StringUtilities.emptyString)
                }
                VStack
                {
                    Text("Microchip")
                    Text(dog.microchip ?? StringUtilities.emptyString)
                }
            }
        }
    }
    
    var mainInfoSection: some View
    {
        Section (header: Text("Mood Result").textCase(nil))
        {
                    ScrollView {
                        EmotionalResultDialogView(predictionResult: resultList)
                    }
        }
    }
    
    var otherInfoSection: some View
    {
        Section (header: Text("Other info").textCase(nil))
        {
            TextEditor(text: $note)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .navigationTitle("Note")
           
        }
    }
    
    func saveCheckAction()
    {
        Task
        {
            showLoading = true
            var info =  await viewModel.addNewEmotionalCheck(note: note, dog: dog, image: image, predictionList: resultList)
            let _ = print("Sto salvando")
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
            }
        }
    }
    
    func buttonIsDisabled()-> Bool
    {
        //TODO: capire se ha senso
        return false
    }
}

/*
#Preview {
    ResultDogMoodContentView()
}*/
