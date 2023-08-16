//
//  PersistenceControllerForPreview.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//

import CoreData

struct PersistenceControllerForPreview {
    static var previewController1: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        
        let viewContext = result.container.viewContext
        let activityType1 = ActivityTypes(context: viewContext)
        activityType1.info = "Tread Mill"
        activityType1.image = "treadmill"
        let activityType2 = ActivityTypes(context: viewContext)
        activityType2.info = "Elliptical"
        activityType2.image = "elliptical"
        let activityType3 = ActivityTypes(context: viewContext)
        activityType3.info = "Rowing"
        activityType3.image = "rowing"
        
        do {
            try viewContext.save()
        } catch {
            let nsErr = error as NSError
            fatalError("Unresolved error \(nsErr), \(nsErr.userInfo)")
        }
        
        return result
    }()
}
