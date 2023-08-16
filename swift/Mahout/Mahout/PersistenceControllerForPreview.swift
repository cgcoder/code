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
        activityType1.id = "1"
        activityType1.name = "Tread Mill"
        activityType1.info = "Walk / Jog on a thread mill"
        activityType1.image = "treadmill"
        activityType1.units = ActivityTypeUnitValue(units: [.inclination, .distanceMiles, .distanceKm])
        let activityType2 = ActivityTypes(context: viewContext)
        activityType2.id = "2"
        activityType2.name = "Elliptical"
        activityType2.info = "Work out your leg on an elliptical"
        activityType2.image = "elliptical"
        activityType2.units = ActivityTypeUnitValue(units: [.friction, .duration])
        let activityType3 = ActivityTypes(context: viewContext)
        activityType3.id = "3"
        activityType3.name = "Rowing"
        activityType3.info = "Whole body workout using a rowing machine"
        activityType3.image = "rowing"
        activityType3.units = ActivityTypeUnitValue(units: [.friction, .duration])
        
        do {
            try viewContext.save()
        } catch {
            let nsErr = error as NSError
            fatalError("Unresolved error \(nsErr), \(nsErr.userInfo)")
        }
        
        return result
    }()
}
