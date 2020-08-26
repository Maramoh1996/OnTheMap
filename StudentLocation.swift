//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Maram Moh on 13/07/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
 
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    var ACL: String?
    
}
extension StudentLocation {
    init(mapString: String) {
        self.mapString = mapString
    }
}
