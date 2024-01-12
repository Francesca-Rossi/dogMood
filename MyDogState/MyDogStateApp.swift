//
//  MyDogStateApp.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

@main
struct MyDogStateApp: App {
    
    @StateObject var viewModel = DogViewModel()
    var body: some Scene {
        WindowGroup {
            let _ = Logger.shared.printDocumentsDirectory()
            ContentView()
        }
    }
}
