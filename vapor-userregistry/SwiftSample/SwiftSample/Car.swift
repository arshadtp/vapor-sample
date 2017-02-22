//
//  Car.swift
//  SwiftSample
//
//  Created by qbuser on 16/02/17.
//  Copyright © 2017 qbuser. All rights reserved.
//

import UIKit
import SwiftyJSON
class Car: NSObject {
    var model: String
    var make: String
    var imageUrl : String?
    var updatedDate: TimeInterval?
    init(detail: JSON) {
        model = detail["model"].string!
        make = detail["make"].string!
       
        imageUrl = detail["imageURL"].string ?? ""
        updatedDate = detail["updatedDate"].doubleValue
    }
}
