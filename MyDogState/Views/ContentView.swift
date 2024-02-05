//
//  CustomBottomMenuView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 17/10/23.
//

import SwiftUI

struct ContentView: View {

   @StateObject var dogVM: DogViewModel = DogViewModel()
   @State private var loadingDelayOk = false
   var body: some View {
        if loadingDelayOk == false
        {
            CustomProgressView(title: "Loading").onAppear{
               //TODO: aggiungi un commento
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    loadingDelayOk = true
                }
            }
        }
        else
        {
            tabBar
        }
    }
    var tabBar: some View
    {
        NavigationView {
            TabView {
                DogsListContentView().environmentObject(dogVM)
                    .tabItem {
                        Image(systemName: "pawprint.fill")
                        Text("My dogs")
                    }
                if !dogVM.isDogListEmpty
                {
                    let checkVM = CheckMoodViewModel()
                    CheckListContentView(dogVM: dogVM).environmentObject(checkVM)
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("History check")
                        }
                }
            }.toolbarBackground(.red, for: .tabBar)
        }
    }
}


/*#Preview {
    
    CustomBottomMenuView(viewModel: DogViewModel())
}*/
