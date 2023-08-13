//
//  ContentView.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/12/23.
//

import SwiftUI

struct MainView: View {
    private var bgColors: [Color] = [ .indigo, .yellow, .green, .orange, .brown ]

    var body: some View {
        TabView {
            WorkoutView()
                .tabItem {
                    Label("Work Out", systemImage: "square.and.pencil")
                }
            PlanView()
                .tabItem {
                    Label("Plan", systemImage: "book")
                }
            LogView()
                .tabItem {
                    Label("Log", systemImage: "clock")
                }
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }.accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().navigationTitle("Pick your color")
    }
}
