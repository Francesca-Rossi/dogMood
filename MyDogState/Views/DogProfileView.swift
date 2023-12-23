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
                    Text(dog.name ?? "").font(.system(size: 36)).bold()
                    ChipView(chip: (dog.sex ?? "", dog.getSexColor()))
                }
                TextWithIcon(iconName: "pencil", caption: dog.dateOfBirth?.formatted(date: .abbreviated, time: .omitted) ?? "")
                TextWithIcon(iconName: "pencil", caption: dog.microchip ?? "")
                TextWithIcon(iconName: "pencil", caption: dog.hairColor ?? "")
                TextWithIcon(iconName: "pencil", caption: dog.breed ?? "")
                
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
