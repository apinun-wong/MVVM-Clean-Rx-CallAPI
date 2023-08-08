//
//  FoodModelResponse.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 8/8/2566 BE.
//

import Foundation

struct FoodModelResponse {
    let id: Int
    let type: FoodType
    let typeName: String
    let data: [FoodData]
}

struct FoodData {
    let calories, name: String
    let type: FoodType
    let portion: String
}

extension FoodModelResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case type_name
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let foodTypeString = try container.decode(String.self, forKey: .type)
        type = FoodType(rawValue: foodTypeString) ?? .unowned
        typeName = try container.decode(String.self, forKey: .type_name)
        data = try container.decodeIfPresent([FoodData].self, forKey: .data) ?? []
    }
}

extension FoodData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case portion
        case type
        case name
        case calories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        portion = try container.decode(String.self, forKey: .portion)
        let foodTypeString = try container.decode(String.self, forKey: .type)
        type = FoodType(rawValue: foodTypeString) ?? .unowned
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(String.self, forKey: .calories)
    }
}
