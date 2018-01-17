//
//  Item.swift
//  LetsDoIt
//
//  Created by Mohsin Ajmal on 1/17/18.
//  Copyright © 2018 Mohsin Ajmal. All rights reserved.
//

import Foundation

class Item : Codable {
    var title : String = ""
    var done : Bool = false
    
    init(itemTitle: String, itemDone: Bool ) {
        title = itemTitle
        done = itemDone
    }
}
