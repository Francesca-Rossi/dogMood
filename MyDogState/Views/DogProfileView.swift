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
        VStack
        {
            if let data = dog.image, let image = UIImage(data: data)
            {
                CircleImage(image: image, width: CGFloat(200), height: CGFloat(200))
            }
            VStack(alignment: .center)
            {
                Divider()
                VStack(alignment: .leading)
                {
                    
                    titleInfo //name, sex
                    bodyInfo  //birthday, microchip, breed, hair color
                }
                Divider()
            }
            
        }
    }
    
    /***
     titleInfo
     Includes:
     - dog's name
     - dog's sex
     ***/
    var titleInfo: some View
    {
        HStack
        {
            Text(dog.name ?? StringUtilities.emptyString)
                .font(.system(size: 36))
                .bold()
                .frame(alignment: .trailing)
            if let sexChip = dog.getSexChip()
            {
                ChipView(chip: sexChip)
                    .frame(width: 100, alignment: .trailing)
            }
        }
    }
    
    /***
     BodyInfo:
     Includes:
     -  birthday date
     - microchip
     - bread
     - color
     ***/
    var bodyInfo: some View
    {
        Group
        {
            if let microchip = dog.microchip, !microchip.isEmpty
            {
                CustomLabel(icon: "cpu", caption: microchip)
            }
            if let date = dog.formatedDateOfBirthday()
            {
                CustomLabel(icon: "birthday.cake.fill", caption: date)
            }
            if let hairColor = dog.hairColor, !hairColor.isEmpty
            {
                //TODO: sarebbe meglio metterci un pallino con il colore del cane
                CustomLabel(icon: "eyedropper", caption: hairColor)
            }
            if let breed = dog.breed, !breed.isEmpty
            {
                CustomLabel(icon: "pawprint.fill", caption: breed)
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
