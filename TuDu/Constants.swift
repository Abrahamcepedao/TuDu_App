//
//  Constants.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 08/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import Foundation

struct K {
    struct CellIdentifiers {
        static let categoryCellTV = "CategoryCellTV" // category cell
        static let activityCellTV = "ActivityCellTV" // activity cell
        static let ACcolorCellCV = "ColorCellCV" // add category color cell
        static let ECcolorCellCV = "ECColorCellCV" // edit category color cell
        static let AAcategoryCell = "AAcategoryCell" // add Activity category cell
    }
    struct Segues {
        static let addCategorySegue = "addCategorySegue"
        static let editCategorySegue = "editCategorySegue"
        static let addActivitySegue = "addActivitySegue"
        static let editActivitySegue = "editActivitySegue"
    }
    struct Nibs {
        static let categoryCellNib = "CategoryCell"
        static let activityCellNib = "ActivityCell"
    }
}
