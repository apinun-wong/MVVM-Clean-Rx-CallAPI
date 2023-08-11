//
//  FontUtils.swift
//  SMBBusinessCard
//
//  Created by Apinun on 11/7/2566 BE.
//

import UIKit
class FontUtils {
    static func printFontsFamily() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}
