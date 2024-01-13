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
                        if let imageData = check.image
                        {
                            ItemCellView(
                                image: UIImage(data: imageData), 
                                title: check.dog?.name,
                                chipFields: createChip(check: check),
                                firstLabel: formatedDate(check: check),
                                secondLabel: check.note,
                                parentViewType: .states
                                )
                                .onTapGesture {
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
    func formatedDate(check: MoodCheckInfo) -> String?
    {
        return check.date?.formatted(date: .long, time: .standard)
    }
    func createChip(check: MoodCheckInfo) -> Chip?
    {
        if let moodDetail = check.dog?.getTheBestConfidenceMood(check: check)
        {
            return moodDetail.getMoodChip()
        }
        return nil
    }
}

/*#Preview {
    CheckListView()
}*/
