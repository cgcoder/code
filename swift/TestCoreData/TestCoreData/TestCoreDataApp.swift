//
//  TestCoreDataApp.swift
//  TestCoreData
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//

import SwiftUI

@main
struct TestCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
