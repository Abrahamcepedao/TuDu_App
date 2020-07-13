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
        static let categoryCellTV = "CategoryCellTV"
        static let activityCellTV = "ActivityCellTV"
        static let ACcolorCellCV = "ColorCellCV" // add category
        static let ECcolorCellCV = "ECColorCellCV" // edit category
    }
    struct Segues {
        static let addCategorySegue = "addCategorySegue"
        static let editCategorySegue = "editCategorySegue"
    }
    struct Nibs {
        static let categoryCellNib = "CategoryCell"
        static let activityCellNib = "ActivityCell"
    }
}
