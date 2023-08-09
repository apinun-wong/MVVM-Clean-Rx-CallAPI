//
//  FoodItemsListRequest.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 9/8/2566 BE.
//

import Foundation

enum FoodItemsListRequest {
    case getFoodItemList
}

extension FoodItemsListRequest: Request {
    var method: RequestMethod {
        switch self {
        case .getFoodItemList:
            return .GET
        }
    }
    
    var host: String {
        return baseUrlPath
    }
    
    var path: String {
        switch self {
        case .getFoodItemList:
            return "/ThaiFood"
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var params: Encodable? {
        return nil
    }
    
    var urlParams: Encodable? {
        return nil
    }
}
