//
//  MenuHomeCollectionViewCell.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 10/8/2566 BE.
//

import UIKit

class MenuHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func setUp(text: String) {
        self.titleLabel.text = text
    }
}
