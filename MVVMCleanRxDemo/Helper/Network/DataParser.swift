//
//  DataParser.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 9/8/2566 BE.
//

import Foundation

public protocol DataParser {
    func parse<T: Decodable>(_ data: Data) async throws -> T
}

public class DataParserImpl: DataParser {
    public init() {}

    public func parse<T>(_ data: Data) async throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        let defaultDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.calendar = Calendar(identifier: .gregorian)
        defaultDecoder.dateDecodingStrategy = .formatted(formatter)
        return try decoder.decode(T.self, from: data)
    }
}
