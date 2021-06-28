//
//  UploadFileModelFabric.swift
//  TestCase
//
//  Created by Anton Scherbaev on 28.06.2021.
//

import Foundation

struct UploadFileModelFactory {
    func convertPhotosForUpload(fromObject: [PhotoObject]) -> [UploadFileModel] {
        var array = [UploadFileModel]()
        for item in fromObject {
            array.append(UploadFileModel(fileData: item.photoData, fileName: item.id.stringValue + ".jpeg"))
        }
        return array
    }
    func convertRealmDumpForUpload(fromFile: Data) -> [UploadFileModel] {
        [UploadFileModel(fileData: fromFile, fileName: "default.realm")]
    }
}
