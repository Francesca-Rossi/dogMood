//
//  MoodDetailView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 13/01/24.
//

import SwiftUI

struct CheckDetailView: View {
    var checkDetail: MoodCheckInfo
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack
            {
                if let data = checkDetail.image, let image = UIImage(data: data)
                {
                    CircleImage(image: image, width: CGFloat(200), height: CGFloat(200))
                }
                VStack(alignment: .center)
                {
                    VStack(alignment: .leading)
                    {
                        dogName //name
                        headerInfo  //date, mood
                        if let note = checkDetail.note
                        {
                            Text(note)
                        }
                    }
                    EmotionalResultDialogView(predictionResult: checkDetail.convertToPredictions())
                }
            }
            .navigationTitle("Check detail")
            .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button
                        {
                            dismiss()
                        } label: {
                            Label("Go back", systemImage: "chevron.left")
                        }
                    }
                }
        }.navigationViewStyle(.stack)
    }
    
    /***
     - dog's name
     ***/
    var dogName: some View
    {
        Text(checkDetail.dog?.name ?? StringUtilities.emptyString)
            .font(.system(size: 36))
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var headerInfo: some View
    {
        HStack
        {
            if let date = checkDetail.dateToString()
            {
                CustomLabel(icon: "calendar.badge.clock", caption: date )
            }
            if let mood = checkDetail.getTheBestConfidenceMood()
            {
                ChipView(chip: mood.getMoodChip())
                    .frame(maxWidth: 120)
            }
        }
    }
}

/*#Preview {
    CheckDetailView()
}*/
