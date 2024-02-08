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
        //var dogName = dog.name ?? StringUtilities.emptyString
    
        NavigationView
        {
            VStack
            {
                Form
                {
                    dogInfoSection
                    dogImageSection
                    mainInfoSection
                    otherInfoSection
                }
                Button(action: saveCheckAction)
                {
                    saveButtonTitle
                }.disabled(buttonIsDisabled())
                .buttonStyle(AnimatedCapsulePurpleButtonStyle())
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
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Save new mood")
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
                .minimumScaleFactor(0.5)
        }
    }
    var dogImageSection: some View
    {
        VStack(alignment: .center)
        {
            Section (header: Text("Check photo").textCase(nil).minimumScaleFactor(0.5))
            {
                
                RoundedRectagleImage(image: image, width: CGFloat(100.0), height: CGFloat(100.0))
                
            }
        }
    }
    
    var dogInfoSection: some View
    {
        Section (header: Text("Dog Info").textCase(nil).minimumScaleFactor(0.5))
        {
            VStack
            {
                if let dogName = dog.name, !dogName.isEmpty
                {
                    CustomLabel(icon: "pawprint.fill", caption: dogName)
                }
                if let microchip = dog.microchip, !microchip.isEmpty
                {
                    CustomLabel(icon: "cpu", caption: microchip)
                }
            }
        }
    }
    
    var mainInfoSection: some View
    {
        Section (header: Text("Mood Result").textCase(nil).minimumScaleFactor(0.5))
        {
                    ScrollView {
                        EmotionalResultDialogView(predictionResult: resultList)
                    }
        }
    }
    
    var otherInfoSection: some View
    {
        Section (header: Text("Other info").textCase(nil).minimumScaleFactor(0.5))
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
