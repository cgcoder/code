//
//  ManageWorkoutActivitiesView.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//

import SwiftUI

struct ManageWorkoutActivitiesView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)], predicate: nil, animation: .default) private var activities: FetchedResults<ActivityTypes>
    
    @State var search: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Search", text: $search)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                .textFieldStyle(.roundedBorder)
            List {
                ForEach(activities.filter { f in
                    search.count == 0 || f.name!.lowercased().contains(search.lowercased())
                }, id: \.self) { activity in
                    NavigationLink(destination: ManageActivityType(model: activity.asUIModel())) {
                        ActivityRowView(activity: activity)
                    }
                }
            }
        }
        .navigationTitle("Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ManageActivityType()) {
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
        print("\(activity.name) \(activity.image ?? "empty")")
        if let url = activity.image, let image = UIImage(named: url.lowercased()) {
            return image
        }
        if let data = activity.imageData, let image = UIImage(data: data) {
            return image
        }
        return UIImage(named: "noimage")!
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: activityImage)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .cornerRadius(0)
            VStack(alignment: .leading, spacing: 8) {
                Text(activity.name!)
                Text(activity.info!)
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
