//
//  Category.swift
//  LetsDoIt
//
//  Created by Mohsin Ajmal on 1/18/18.
//  Copyright © 2018 Mohsin Ajmal. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
