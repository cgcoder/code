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
            if let _ = error {
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
    
    func addToRecentlyUsed(context: NSManagedObjectContext, collectionId: UUID) -> Void {
        let used = RecentlyUsed(context: context)
        used.collectionId = collectionId
        used.timestamp = Date.now
        
        for ru in self.recentlyUsed {
            print("Before remove \(ru.collectionId!.uuidString) \(ru.timestamp?.description), to remove \(collectionId.uuidString)")
        }
        
        let oldEntry = self.recentlyUsed.first(where: { $0.collectionId == collectionId })
        if let oldEntry = oldEntry {
            self.recentlyUsed.removeAll(where: { $0.collectionId == collectionId })
            context.delete(oldEntry)
        }
        
        self.recentlyUsed.insert(used, at: 0)
        self.save(context)
        
        for ru in self.recentlyUsed {
            print("after remove \(ru.collectionId?.uuidString ?? "empty") \(ru.timestamp?.description), to remove \(collectionId.uuidString)")
        }
    }
    
    func loadRecentlyUsed(context: NSManagedObjectContext) -> Void {
        let fetchReq: NSFetchRequest<RecentlyUsed> = RecentlyUsed.fetchRequest()
        fetchReq.sortDescriptors = [NSSortDescriptor(keyPath: \RecentlyUsed.collectionId, ascending: false)]
        fetchReq.fetchLimit = 50
        do {
            let fetchResult = try context.fetch(fetchReq)
            self.recentlyUsed = fetchResult
        }
        catch {
            print("error loadRecentlyUsed")
        }
    }
}
