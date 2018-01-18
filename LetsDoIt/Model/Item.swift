//
//  Item.swift
//  LetsDoIt
//
//  Created by Mohsin Ajmal on 1/18/18.
//  Copyright © 2018 Mohsin Ajmal. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
