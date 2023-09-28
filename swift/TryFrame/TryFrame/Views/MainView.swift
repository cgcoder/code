//
//  MainView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/1/23.
//

import SwiftUI

struct MainView: View {
    let gradient = LinearGradient(colors: [Color("BackgroundColorStart"), Color("BackgroundColorEnd")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        NavigationStack(path: $appState.navigationPath) {
            ZStack {
                gradient.ignoresSafeArea()
                HomePageView().padding(10)
            }
            .padding(0)
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(0)
    }
}

#Preview {
    MainView()
}
