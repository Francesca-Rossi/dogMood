//
//  HomeContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 12/09/23.
//

import SwiftUI

struct HomeContentView: View {
    @EnvironmentObject var viewModel: DogViewModel
    var body: some View {
        var item1 = menuItem(view: AnyView(DogsListContentView(viewModel: viewModel)), value: "doglist", imageName: "dog", tags: "dog_list")
        var item2 = menuItem(view: AnyView(SelectableDogListView(viewModel: viewModel, isSelectable: true)), value: "checkDogState", imageName: "dog", tags: "dog_list")
        
        BottomMenuView(viewModel: _viewModel, selectedTab: "dog_list", items: [item1, item2])
    }
}

struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContentView()
    }
}
