//
//  MyDogStateApp.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

@main
struct MyDogStateApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
