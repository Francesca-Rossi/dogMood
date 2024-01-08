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
    
    var body: some View {
        Form
        {
            dogImageSection
            dogInfoSection
            mainInfoSection
            otherInfoSection
        }
        Button(action: saveDogAction)
        {
            saveButtonTitle
        }.disabled(buttonIsDisabled())
            .buttonStyle(AnimatedCapsuleBlueButtonStyle())
    }
    
    var saveButtonTitle: some View
    {
        HStack
        {
            Image(systemName: "square.and.arrow.down")
            Text("Save new dog")
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
    
    func saveDogAction()
    {
        Task
        {
                let info =  await viewModel.addNewEmotionalCheck(note: note, dog: dog, image: image, predictionList: resultList)
                if info.hasErrorInfo()
                {
                    //TODO controllare che funzioni
                    Alert(
                        title: Text("Error"),
                        message: Text(info.getErrorMessage()),
                        dismissButton: .default(Text("OK"))
                    )
                }
            let _ = print("Sto salvando")
            dismiss()
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
