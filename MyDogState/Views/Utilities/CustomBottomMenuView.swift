//
//  CustomBottomMenuView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 17/10/23.
//

import SwiftUI

struct CustomBottomMenuView: View {
    @StateObject var viewModel: DogViewModel
    @StateObject var checkViewModel: CheckMoodViewModel
    @State var tapDogList = false
    @State var tapMoodCheckHistory = false
    @State var tapMooCheckStatus = false
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
                    .sheet(isPresented: $tapMooCheckStatus )
                    {
                        //TODO: check image here
                        SelectableDogListView(viewModel: viewModel, image: .constant(UIImage()))
                    }
                    .disabled(!viewModel.checkDogStatus)
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
                    }.foregroundStyle(tapMoodCheckHistory ? .blue : .black)
                        .fullScreenCover(isPresented: $tapMoodCheckHistory)
                    {
                        CheckListView(viewModel: CheckMoodViewModel())
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
        tapMoodCheckHistory = false
        tapMooCheckStatus = false
    }
    
    func historyListTapped()
    {
        tapDogList = false
        tapMoodCheckHistory = true
        tapMooCheckStatus = false
    }
    
    func checkStatusTapped()
    {
        tapDogList = false
        tapMoodCheckHistory = false
        tapMooCheckStatus = true
    }
}


/*#Preview {
    
    CustomBottomMenuView(viewModel: DogViewModel())
}*/
