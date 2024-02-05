//
//  CheckListContentView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 10/01/24.
//

import SwiftUI
import CoreData

struct CheckListContentView: View {
    @EnvironmentObject var checkVM: CheckMoodViewModel
    @State var dogVM: DogViewModel
    @State private var showingAddView = false
    @State var selectedItem: MoodCheckInfo?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading)
            {
                if checkVM.isCheckListEmpty
                {
                    addNewCheckButton(isToolbar: false)
                        .buttonStyle(AnimatedCapsuleBlueButtonStyle())
                }
                else
                {
                    checkMoodList
                }
            }
            .navigationTitle("All Check")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    addNewCheckButton(isToolbar: true)
                        .disabled(checkVM.isCheckListEmpty)
                }
            }
            .fullScreenCover(isPresented: $showingAddView)
            {
                let _ = Logger.shared.log("Open add new check view", level: LogLevel.Trace , saveToFile: true)
                SelectableDogListView(viewModel: dogVM)
            }
            .fullScreenCover(item: $selectedItem)
            {
                item in
                CheckDetailView(checkDetail: item)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    var checkMoodList: some View
    {
        List{
            ForEach(checkVM.emotionalInfoCheckList)
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
                    await checkVM.deleteCheck(offset: indexSet)
                }
            }
        }.listStyle(PlainListStyle())
            .refreshable {
                Task { await  checkVM.getAllCheckMood()}
            }
    }
    
    func addNewCheckButton(isToolbar: Bool) -> some View
    {
        Button
        {
            showingAddView.toggle()
        }label: {
            if isToolbar
            {
                Label("Add new check", systemImage: "plus.circle")
            }
            else
            {
                HStack
                {
                    Image(systemName: "plus.circle.fill")
                    Text("Check mood now")
                }
            }
        }
    }
    
    func formatedDate(check: MoodCheckInfo) -> String?
    {
        return check.date?.formatted(date: .long, time: .standard)
    }
    
    func createChip(check: MoodCheckInfo) -> Chip?
    {
        if let moodDetail = check.getTheBestConfidenceMood()
        {
            return moodDetail.getMoodChip()
        }
        return nil
    }
}

/*struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 DogsListContentView(viewModel: DogViewModel())
 }
 }*/


/*#Preview {
    CheckListContentView()
}*/
