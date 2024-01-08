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
                
                titleInfo //name, sex
                bodyInfo  //birthday, microchip, breed, hair color
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
            if let sexChip = sexChip
            {
                ChipView(chip: sexChip)
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
                TextWithIcon(icon: "cpu", caption: microchip)
            }
            if let date = dog.dateOfBirth?.formatted(date: .abbreviated, time: .omitted)
            {
                TextWithIcon(icon: "birthday.cake.fill", caption: date)
            }
            if let hairColor = dog.hairColor, !hairColor.isEmpty
            {
                //TODO: sarebbe meglio metterci un pallino con il colore del cane
                TextWithIcon(icon: "eyedropper", caption: hairColor)
            }
            if let breed = dog.breed, !breed.isEmpty
            {
                TextWithIcon(icon: "pawprint.fill", caption: breed)
            }
        }
        
    }
    
    var sexChip: Chip?
    {
        if let sex = dog.sex
        {
            return Chip(title: sex,
                        titleColor: dog.getSexForegroundColor(),
                        bgColor: dog.getSexBackgroundColor())
        }
        return nil
        
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
