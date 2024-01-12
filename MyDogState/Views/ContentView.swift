//
//  CustomBottomMenuView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 17/10/23.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel: DogViewModel = DogViewModel()
    @StateObject var checkViewModel: CheckMoodViewModel = CheckMoodViewModel()
    var body: some View {
           tabBar
    }
    var tabBar: some View
    {
        TabView {
            DogsListContentView().environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("My dogs")
                }
            //TODO: disabilitare questo campo se non ci sono cani
            CheckListContentView().environmentObject(checkViewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("History check")
                }
        }.toolbarBackground(.red, for: .tabBar)
    }

}


/*#Preview {
    
    CustomBottomMenuView(viewModel: DogViewModel())
}*/
