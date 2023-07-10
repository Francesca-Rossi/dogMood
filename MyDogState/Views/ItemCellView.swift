//
//  ItemView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import SwiftUI

struct ItemCellView: View {
    var image: UIImage?
    var title: String?
    var chipTitle: String?
    var chipColor: Color?
    var firstLabel: String?
    var secondLabel: String?
    var parentViewType: ViewParentType
    var body: some View {
        HStack(spacing: 10)
        {
            if let image = image
            {
                RoundedRectagleImage(image: image).padding(.leading)
            }
            VStack(alignment: .leading, spacing: 10)
            {
                HStack(spacing: 0)
                {
                    Text(title ?? "unknown")
                    ChipView(title: chipTitle ?? "unknown", bgColor: chipColor ?? .blue)
                }
                if let firstLabel = firstLabel ?? "unknown", let secondLabel = secondLabel ?? "unknown"
                {
                    switch parentViewType
                    {
                    case .dogs:
                        ItemCellDescriptionViewWithIcon(firstLabel: firstLabel , firstIcon:  "trash.circle", secondLabel:  secondLabel , secondIcon: "trash.circle")
                    case .states:
                        ItemCellDescriptionView(firstLabel: firstLabel, secondLabel: secondLabel)
                    }
                }
            }
            .frame(width: 200, height: 150, alignment: .leading)
            .padding(0)
        }
    }
}

struct ItemCellViewExample : View {
    private var chipTitle = "Chip title"
    private var title = "title"
    private var image = UIImage()
    private var firstLabel = "First"
    private var secondLabel = "Second"
    private var parentViewType = ViewParentType.dogs
    
    var body: some View {
        ItemCellView(image: image, title: title, chipTitle: chipTitle, firstLabel: firstLabel, secondLabel: secondLabel, parentViewType: parentViewType)
    }
}

#if DEBUG
struct ItemCellViewExample_Previews : PreviewProvider {
    static var previews: some View {
        ItemCellViewExample()
    }
}
#endif


//ItemCellDescriptionViewWithIcon Region

struct ItemCellDescriptionViewWithIcon: View
{
    var firstLabel: String
    var firstIcon: String
    
    var secondLabel: String
    var secondIcon: String
    var body: some View
    {
        VStack(alignment: .leading, spacing: 0)
        {
            TextWithIcon(iconName: firstIcon, caption: firstLabel)
            TextWithIcon(iconName: secondIcon, caption: secondLabel)
        }
        
    }
}

struct ItemCellDescriptionViewWithIconExample: View
{
    var firstLabel = "prova 1"
    var secondLabel = "prova 2"
    var firstIcon = "trash"
    var secondIcon = "pencil"
    var body: some View
    {
        VStack(alignment: .leading)
        {
            TextWithIcon(iconName: firstIcon, caption: firstLabel)
            TextWithIcon(iconName: secondIcon, caption: secondLabel)
        }
    }
}


#if DEBUG
struct ItemCellDescriptionViewWithIconExample_Previews : PreviewProvider {
    static var previews: some View {
        ItemCellDescriptionViewWithIconExample()
    }
}
#endif

//ItemCellDescriptionView Region

struct ItemCellDescriptionView: View
{
    var firstLabel: String
    var secondLabel: String
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text(firstLabel)
            Text(secondLabel)
        }
    }
}

struct ItemCellDescriptionViewExample: View
{
    var firstLabel = "first"
    var secondLabel = "second"
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text(firstLabel)
            Text(secondLabel)
        }
    }
}

#if DEBUG
struct ItemCellDescriptionViewExample_Previews : PreviewProvider {
    static var previews: some View {
        ItemCellDescriptionViewExample()
    }
}
#endif


