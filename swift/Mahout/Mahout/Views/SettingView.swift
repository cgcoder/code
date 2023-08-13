//
//  SettingView.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/12/23.
//

import SwiftUI

struct SettingView: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink { ManageWorkoutActivitiesView() } label: { Text("Manage Workout Plan")
                }
                NavigationLink { ManageWorkoutActivitiesView() } label: { Text("Manage Workout Activities")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Settings")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
