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
                Image(systemName:  "checkmark.circle").padding(.leading)
            }
            else
            {
                Image(systemName:  "circle").padding(.leading)
            }
            if let dog = dog, let imageData = dog.image
            {
                ItemCellView(image: UIImage(data: imageData) ?? UIImage(), title: dog.name, chipFields: Chip(title: dog.sex ?? StringUtilities.emptyString, titleColor: dog.getSexForegroundColor(), bgColor: dog.getSexBackgroundColor()), subtitle: dog.microchip, description: DateFormatter().string(for: dog.dateOfBirth), parentViewType: .dogs)
            }
        }
    }
}

/*#Preview {
    SelectableRowDogCellView()
}*/
