//
//  BottomMenu.swift
//  MyDogState
//
//  Created by Francesca Rossi on 12/09/23.
//

import SwiftUI
/*
struct BottomMenuView: View {
    @EnvironmentObject var viewModel: DogViewModel
    @State var selectedTab: String
    var items: [menuItem]
    var body: some View {
        TabView(selection: $selectedTab)
        {
            ForEach(items) { item in
                item.view
                    .tabItem{
                        Text(item.value)
                        Image(item.imageName)
                    }
                    //.tags(item.tags)
                //TODO: trova una soluzione per il tags
            }
        }
    }
}

/*struct BottomMenu_Previews: PreviewProvider {
    static var previews: some View {
        //BottomMenu(selectedTab: "dog_list")
    }
}*/

struct menuItem: Identifiable
{
    let id = UUID()
    var view: AnyView
    var value: String
    var imageName: String
    var tags: String
}*/
