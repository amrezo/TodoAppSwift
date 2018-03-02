//
//  ToDoListItem.swift
//  TodoApp
//
//  Created by Amr Al-Refae on 3/1/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoListItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var done = false
}
