//
//  Item.swift
//  Todoliee
//
//  Created by Babak Farahanchi on 2018-02-19.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
