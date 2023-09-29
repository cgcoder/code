//
//  AppData.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/28/23.
//

import Foundation
import CoreData

extension GlobalAppState {
    func loadDataFromCoreData() {
        self.dataContainer.loadPersistentStores { desc, error in
            if let error = error {
                self.dbLoadStatus = .error(message: "Unable to load the data.")
            }
        }
    }
    
    func save(_ context: NSManagedObjectContext) {
        self.dbSaveStatus = .progress
        do {
            try context.save()
            self.dbSaveStatus = .done
        }
        catch {
            self.dbSaveStatus = .error(message: "Unable to save the data.")
        }
    }
    
    func updateFavorite(context: NSManagedObjectContext, collectionId: UUID) {
        let favorite = self.favorites.first(where: { $0.collectionId == collectionId })
        
        if let favorite = favorite {
            self.favorites.remove(favorite)
            context.delete(favorite)
        }
        else {
            let favorite = Favorites(context: context)
            favorite.collectionId = collectionId
            favorite.timestamp = Date()
            self.save(context)
            self.favorites.insert(favorite)
        }
    }
    
    func loadFavorites(context: NSManagedObjectContext) -> Void {
        let fetchReq: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        fetchReq.fetchLimit = 50
        do {
            let fetchResult = try context.fetch(fetchReq)
            self.favorites = self.favorites.union(fetchResult)
        }
        catch {
            print("error loadfavorites")
        }
    }
}
