//
//  MovieFanApp.swift
//  MovieFan
//
//  Created by Chandrasekaran, Gopinath on 8/8/23.
//

import SwiftUI

@main
struct MovieFanApp: App {
    
    @StateObject private var dataController = DataController()
    @State private var name = "test"
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
            
        }
    }
}
