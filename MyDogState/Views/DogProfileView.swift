//
//  DogProfileView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 13/07/23.
//

import SwiftUI

struct DogProfileView: View
{
    var dog: Dog
    var body: some View {
        HStack
        {
            if let data = dog.image, let image = UIImage(data: data) 
            {
                CircleImage(image: image)
            }
            VStack(alignment: .leading)
            {
                HStack
                {
                    Text(dog.name ?? StringUtilities.emptyString).font(.system(size: 36)).bold()
                    ChipView(chip: Chip(title: dog.sex ?? StringUtilities.emptyString, titleColor: dog.getSexForegroundColor(), bgColor: dog.getSexBackgroundColor()))
                }
                TextWithIcon(iconName: "pencil", caption: dog.dateOfBirth?.formatted(date: .abbreviated, time: .omitted) ?? StringUtilities.emptyString)
                TextWithIcon(iconName: "pencil", caption: dog.microchip ?? StringUtilities.emptyString)
                TextWithIcon(iconName: "pencil", caption: dog.hairColor ?? StringUtilities.emptyString)
                TextWithIcon(iconName: "pencil", caption: dog.breed ?? StringUtilities.emptyString)
                
            }
            
        }
    }
}

struct DogProfileViewExample : View {
    private var dog = Dog(id: UUID(), name: "pluto", microchip: "12234", dateOfBirth: Date(), image: nil, breed: "Pastore", sex: "Boy", hairColor: "Marrone", date: Date(), emotionalCheckList: nil)
    
    var body: some View {
        DogProfileView(dog: dog)
    }
}

#if DEBUG
struct DogProfileViewExample_Previews : PreviewProvider {
    static var previews: some View {
        DogProfileViewExample()
    }
}
#endif

/*struct DogProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DogProfileView()
    }
}*/
