//
//  Category.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 03/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var color: String = ""
    @objc  dynamic var selected: Bool = false
    let activities = List<Activity>()
}
