//
//  SelectableRowDogCellView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 23/10/23.
//

import SwiftUI

struct SelectableRowDogCellView: View {
    let dog: Dog?
    @Binding var selectedItem: Dog?
    var body: some View {
        HStack
        {
            if dog == selectedItem
            {
                Image(systemName:"checkmark.circle").padding(.leading)
            }
            else
            {
                Image(systemName:"circle").padding(.leading)
            }
            if let dog = dog, let imageData = dog.image
            {
                ItemCellView(
                    image: UIImage(data: imageData),
                    title: dog.name,
                    chipFields: dog.getSexChip(),
                    firstLabel: dog.microchip,
                    secondLabel: dog.formatedDateOfBirthday(),
                    parentViewType: .dogs
                )
            }
        }
    }
}

/*#Preview {
    SelectableRowDogCellView()
}*/
