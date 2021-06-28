//
//  RealmLogic.swift
//  TestCase
//
//  Created by Anton Scherbaev on 27.06.2021.
//

import Foundation
import RealmSwift

protocol DBLogicSupport {
    func saveToDB (objects: [Object], complition: (_ isSuccess: Bool) -> Void)
    func loadUnrecievedFromDB() -> Results<PhotoObject>?
    func getDumpFile() -> Data?
    func clearStorage()
    func updateObjects(updateObjectsBlock: () -> Void, complition: (Bool) -> Void)
}

class RealmLogic: DBLogicSupport {
    
    private var realm: Realm? {
        try? Realm()
    }
    
    func updateObjects(updateObjectsBlock: () -> Void, complition: (Bool) -> Void) {
        guard let realm = realm else {
            complition(false)
            return
        }
        do {
            try realm.write {
                updateObjectsBlock()
            }
            complition(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            complition(false)
        }
    }
        
    func saveToDB(objects: [Object], complition: (Bool) -> Void) {
        guard let realm = realm else {
            complition(false)
            return
        }
        do {
            try realm.write {
                realm.add(objects)
            }
            complition(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            complition(false)
        }
    }
    
    func loadUnrecievedFromDB() -> Results<PhotoObject>? {
        guard let realm = realm else { return nil }
        let result = realm.objects(PhotoObject.self)
            .filter("sendPictureDate == nil")
        return result
    }
        
    func getDumpFile() -> Data? {
        guard let path = realm?.configuration.fileURL else { return nil }
        return try? Data(contentsOf: path)
    }
    
    func clearStorage() {
        guard let realm = realm else { return }

        try? realm.write({
            realm.deleteAll()
        })
    }
    
    
}
