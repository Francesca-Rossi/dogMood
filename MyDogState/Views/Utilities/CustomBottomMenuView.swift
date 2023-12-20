//
//  CustomBottomMenuView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 17/10/23.
//

import SwiftUI

struct CustomBottomMenuView: View {
    @StateObject var viewModel: DogViewModel
    @State var tapDogList = false
    @State var tapStatusHistory = false
    @State var tapCheckStatus = false
    var body: some View {
            VStack(alignment: .center, spacing: -20)
            {
                HStack
                {
                    //MARK: - Check status button
                    Button(action: checkStatusTapped)
                    {
                        Image("dog_paw_filled").renderingMode(.template)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(AnimatedCircleBlueButtonStyle())
                    .fullScreenCover(isPresented: $tapCheckStatus )
                    {
                        SelectableDogListView(viewModel: viewModel, image: .constant(UIImage()))
                    }
                }
                HStack(spacing: 200)
                {
                    //MARK: - Status history list button
                    Button(action: historyListTapped)
                    {
                        VStack
                        {
                            Image(systemName: "star")
                            Text("History")
                        }
                    }.foregroundStyle(tapStatusHistory ? .blue : .black)
                    .fullScreenCover(isPresented: $tapStatusHistory)  
                    {
                        //TODO: change with history list
                        DogListView(viewModel: self.viewModel)
                    }
                    //MARK: - My dogs list button
                    Button(action: dogListTapped)
                    {
                        VStack
                        {
                            Image("dog").renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                            Text("My dogs")
                        }
                    }.foregroundStyle(tapDogList ? .blue : .black)
                        .fullScreenCover(isPresented: $tapDogList)  
                    {
                            DogListView(viewModel: self.viewModel)
                    }
                }
            }
    }
    
    func dogListTapped()
    {
        tapDogList = true
        tapStatusHistory = false
        tapCheckStatus = false
    }
    
    func historyListTapped()
    {
        tapDogList = false
        tapStatusHistory = true
        tapCheckStatus = false
    }
    
    func checkStatusTapped()
    {
        tapDogList = false
        tapStatusHistory = false
        tapCheckStatus = true
    }
}


#Preview {
    
    CustomBottomMenuView(viewModel: DogViewModel())
}
