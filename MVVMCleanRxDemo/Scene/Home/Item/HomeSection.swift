//
//  HomeSection.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 10/8/2566 BE.
//

import Foundation

final class HomeSectionType: Hashable {
    var id: Int
    var items: [HomeItemType]
    
    init(id: Int, item: [HomeItemType]) {
        self.id = id
        self.items = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: HomeSectionType, rhs: HomeSectionType) -> Bool {
        lhs.id == rhs.id
    }
}

struct HomeItemType: Hashable {
    let id: String
    let title: String
}
