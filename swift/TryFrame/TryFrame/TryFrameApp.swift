//
//  TryFrameApp.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/24/23.
//

import SwiftUI

@main
struct TryFrameApp: App {
    
    @StateObject var globalState: GlobalAppState = GlobalAppState()
    
    init() {
        // _state = StateObject(wrappedValue: GlobalAppState())
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(globalState)
                .environment(\.managedObjectContext, globalState.dataContainer.viewContext)
                .onAppear {
                    globalState.initialize()
                }
            // HomePageView()
            // TestView()
        }
    }
}
