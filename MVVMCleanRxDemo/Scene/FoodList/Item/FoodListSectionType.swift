//
//  FoodListSectionType.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 11/8/2566 BE.
//

import Foundation

final class FoodListSectionType: Hashable {
    var id: Int
    var items: [FoodListItemType]
    
    init(id: Int, item: [FoodListItemType]) {
        self.id = id
        self.items = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: FoodListSectionType, rhs: FoodListSectionType) -> Bool {
        lhs.id == rhs.id
    }
}

struct FoodListItemType: Hashable {
    let id: String
    let foodName: String
    let callories: String
    let portion: String
}
