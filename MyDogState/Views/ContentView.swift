//
//  CustomBottomMenuView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 17/10/23.
//

import SwiftUI

struct ContentView: View {

    @StateObject var dogVM: DogViewModel = DogViewModel()
    @StateObject var checkVM: CheckMoodViewModel = CheckMoodViewModel()
    var body: some View {
           tabBar
    }
    var tabBar: some View
    {
        TabView {
            DogsListContentView().environmentObject(dogVM)
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("My dogs")
                }
            if !dogVM.isDogListEmpty
            {
                CheckListContentView().environmentObject(checkVM)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("History check")
                    }
            }
        }.toolbarBackground(.red, for: .tabBar)
    }

}


/*#Preview {
    
    CustomBottomMenuView(viewModel: DogViewModel())
}*/
