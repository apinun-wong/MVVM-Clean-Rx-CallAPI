//
//  FoodListItemTableViewCell.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 11/8/2566 BE.
//

import UIKit

class FoodListItemTableViewCell: UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var calloriesLabel: UILabel!
    @IBOutlet weak var portionLabel: UILabel!
    
    func setUp(foodName: String, calloriesText: String, portionText: String) {
        self.foodNameLabel.text = foodName
        self.calloriesLabel.text = calloriesText
        self.portionLabel.text = portionText
    }
}
