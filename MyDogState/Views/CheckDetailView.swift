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
                    CircleImage(image: image, width: CGFloat(150), height: CGFloat(150))
                }
                VStack(alignment: .center)
                {
                    dogName //name
                    VStack(alignment: .leading)
                    {
                        headerInfo  //date, mood
                        if let note = checkDetail.note
                        {
                            Text(note)
                            .font(.footnote)
                            .padding(.leading)
                            .padding(.trailing)
                        }
                    }
                    EmotionalResultDialogView(predictionResult: checkDetail.convertToPredictions())
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))     
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                    ToolbarItem(placement: .principal){
                        Text("Check details")
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
                    }
                }
        }.navigationViewStyle(.stack)
    }
    
    
    var dogName: some View
    {
        Text(checkDetail.dog?.name ?? StringUtilities.emptyString)
            .font(.system(size: 36))
            .bold()
            .frame(maxWidth: .infinity)
    }
    
    var headerInfo: some View
    {
        HStack()
        {
            if let date = checkDetail.dateToString()
            {
                CustomLabel(icon: "calendar.badge.clock", caption: date )
                    .padding(.leading)
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
