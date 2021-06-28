//
//  PhotoObject.swift
//  TestCase
//
//  Created by Anton Scherbaev on 27.06.2021.
//

import Foundation
import  RealmSwift

class PhotoObject: Object {
    @objc dynamic var id = ObjectId.generate()
    @objc dynamic var photoData = Data()
    @objc dynamic var takePictureDate = Date(timeIntervalSinceNow: 0)
    @objc dynamic var sendPictureDate: Date? = nil

    override static func primaryKey() -> String? {
            return "id"
        }
    
    convenience init(image: UIImage) {
        self.init()
        if let data = image.jpegData(compressionQuality: 0.2) {
            photoData = data
        }
    }
}
