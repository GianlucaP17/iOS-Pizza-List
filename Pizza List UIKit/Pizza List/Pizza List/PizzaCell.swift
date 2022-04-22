//
//  ZizzaCell.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright (c) Gianluca Posca. All rights reserved.
//

import UIKit

/// questa classe pliota la cella personalizzata nella table del Master
class PizzaCell: UITableViewCell {

    /// tutti i collegamenti dalla cella nello storyboard
    @IBOutlet var immaginePizza: UIImageView!
    @IBOutlet var viewColoreCalorie: UIView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelIngredienti: UILabel!

}
