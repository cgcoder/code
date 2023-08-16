//
//  MahoutApp.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/12/23.
//

import SwiftUI
import CoreData

@main
struct MahoutApp: App {
    
    let persistenceController = PersistenceControllerForPreview.previewController1
    
    var body: some Scene {
        WindowGroup {
            MainView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
