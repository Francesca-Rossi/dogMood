//
//  CheckListView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 10/01/24.
//

import SwiftUI

struct CheckListView: View {
    @StateObject var viewModel: CheckMoodViewModel
    @State var selectedItem: MoodCheckInfo?
    var body: some View {
        NavigationView {
            VStack
            {
                List{
                    ForEach(viewModel.emotionalInfoCheckList)
                    {
                        check in
                        //Controlla questo if..
                        if let imageData = check.image
                        {
                            ItemCellView(image: UIImage(data: imageData) ?? UIImage(), title: check.dog?.name, chipFields: createChip(check: check), subtitle: formatedDate(check: check), description: check.note, parentViewType: .states)
                                .listRowInsets(EdgeInsets()).onTapGesture {
                                    self.selectedItem = check
                                }
                        }
                        
                    }
                    .onDelete{
                        indexSet in
                        Task
                        {
                            await viewModel.deleteCheck(offset: indexSet)
                        }
                    }
                }.listStyle(PlainListStyle())
                    .refreshable {
                       Task { await  viewModel.getAllCheckMood()}
                    }
                //MARK: - Main bottom menu
                
                //CustomBottomMenuView()
            }
        }
        .fullScreenCover(item: $selectedItem)
        {
            item in
            //TODO: qui apriremo il check
            //DogDetailView( dog: item)
        }
    }
    func formatedDate(check: MoodCheckInfo) -> String
    {
        return check.date?.formatted(date: .long, time: .standard) ?? StringUtilities.emptyString
    }
    func createChip(check: MoodCheckInfo) -> Chip?
    {
        if let moodDetail = check.dog?.getTheBestConfidenceMood(check: check)
        {
            return Chip(
                title: MoodResult.toString(mood: moodDetail.mood),
                titleColor: moodDetail.getMoodForegroundColor(),
                bgColor: moodDetail.getMoodBackgroundColor())
        }
        return nil
    }
}

/*#Preview {
    CheckListView()
}*/
