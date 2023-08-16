//
//  DataController.swift
//  MovieFan
//
//  Created by Chandrasekaran, Gopinath on 8/9/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Data")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data init failed \(error.localizedDescription)")
            }
        }
    }
}
