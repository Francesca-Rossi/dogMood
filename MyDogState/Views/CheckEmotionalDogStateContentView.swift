//
//  CheckEmotionalDogStateContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import SwiftUI
struct CheckEmotionalDogStateContentView: View {
    @State var selectedDog: Dog
    @StateObject var viewModel: CheckMoodViewModel
    @StateObject var classificationServiceViewModel = ClassificationsViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var note = ""
    @State private var onContinueTap = false
    @State private var goBackHome = false
    @State private var isAllOk = false
    @State private var showError = false
    @State var showLoading = false
    
    
    var body: some View {
        NavigationView {
            VStack
            {
                if let image = classificationServiceViewModel.importedImage 
                {
                    ZStack
                    {
                        VStack(alignment: .center, spacing: 5)
                        {
                            if let dogName = selectedDog.name
                            {
                                Text(dogName)
                                    .font(.title)
                                    .bold()
                            }
                            AddImageView(image: $classificationServiceViewModel.importedImage, parentView: .states)
                            ScrollView
                            {
                                EmotionalResultDialogView(predictionResult: classificationServiceViewModel.classifications)
                            }.frame(maxWidth: .infinity, maxHeight: 250.0)
                            
                            HStack
                            {
                                checkAgainButton
                                continueButton
                                    .alert(String(localized: "Save new mood"), isPresented: $onContinueTap) {
                                        TextField(String(localized: "Add a note"), text: $note, axis: .vertical)
                                            .disableAutocorrection(true)
                                        Button(String(localized: "Cancel")) {onContinueTap.toggle()}
                                        Button("OK", action: saveCheckAction)
                                    }
                                    .alert(String(localized: "Error to register the check"), isPresented: $showError) {
                                        Button("OK") { dismiss() }
                                    }
                                    .fullScreenCover(isPresented: $isAllOk)
                                {
                                    ContentView()
                                }
                            }
                        }.blur(radius: showLoading ? 5 : 0)
                        if showLoading
                        {
                            CustomProgressView(title: String(localized: "Saving"))
                        }
                    }
                }
                else
                {
                    VStack {
                        AddImageView(image: $classificationServiceViewModel.importedImage, parentView: .states)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("Check mood")
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        .bold()
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
        .navigationViewStyle(.stack)
        .onChange(of: classificationServiceViewModel.importedImage) { _ in classificationServiceViewModel.onChangeImage() }
    }

    var continueButton: some View
    {
        Button
        {
            onContinueTap.toggle()
        }label: {
            HStack
            {
                Image(systemName: "arrow.right.circle.fill")
                Text("Continue")
                    .minimumScaleFactor(0.5)
            }
        }.buttonStyle(AnimatedCapsulePurpleButtonStyle())
    }
    
    var checkAgainButton: some View
    {
        Button
        {
            classificationServiceViewModel.importedImage = nil
        }label: {
            HStack
            {
                Image(systemName: "camera")
                Text("Check again")
                    .minimumScaleFactor(0.5)
            }
        }.buttonStyle(AnimatedCapsulePurpleButtonStyle())
    }
    
    func saveCheckAction()
    {
        Task
        {
            var info = ErrorInfo()
            showLoading = true
            if let image = classificationServiceViewModel.importedImage
            {
                info =  await viewModel.addNewEmotionalCheck(note: note, dog: selectedDog, image: image, predictionList: classificationServiceViewModel.classifications)
            }
            else
            {
                info.setErrorMessage(value: "Not check image setted")
                Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
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
            }
        }
    }
}

#if DEBUG
//struct CheckEmotionalDogStateContentView_example: PreviewProvider {
//    static var previews: some View {
        //CheckEmotionalDogStateContentView(selectedDog: Dog())
//    }
//}
#endif

