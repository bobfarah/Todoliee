//
//  Category.swift
//  Todoliee
//
//  Created by Babak Farahanchi on 2018-02-19.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
