//
//  Activity.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 03/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import Foundation
import RealmSwift

class Activity: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var status: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "activities")
}
