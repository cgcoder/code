//
//  ManageWorkoutActivitiesView.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//

import SwiftUI

struct ManageWorkoutActivitiesView: View {
    
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) private var activities: FetchedResults<ActivityTypes>
        
    var body: some View {
        List {
            ForEach(activities, id: \.self) { activity in
                ActivityRowView(activity: activity)
            }
        }.navigationTitle("Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddActivityTypeView()) {
                        Image(systemName: "plus")
                    }
                }
            }
    }
}

struct ActivityRowView: View {
    let activity: ActivityTypes
    
    init(activity: ActivityTypes) {
        self.activity = activity
        print("\(activity.info!) \(activity.image!)")
    }
    
    var activityImage: UIImage {
        if let url = activity.image, let image = UIImage(named: url.lowercased()) {
            return image
        }
        return UIImage(named: "nopicture")!
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: activityImage)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .cornerRadius(0)
            VStack(alignment: .leading, spacing: 8) {
                Text(activity.info!)
                Text("Training on Elliptical")
                    .fontWeight(.ultraLight)
            }
        }
    }
}

struct ManageWorkoutActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageWorkoutActivitiesView().environment(\.managedObjectContext, PersistenceControllerForPreview.previewController1.container.viewContext)
    }
}
