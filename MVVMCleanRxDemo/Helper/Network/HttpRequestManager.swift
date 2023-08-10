//
//  Network.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 8/8/2566 BE.
//

import Foundation

enum NetworkError: Error {
    case invalidServerResponse
    case invalidStatusCode(statusCode: Int)
    case error(statusCode: Int, data: Data)
}

protocol HttpRequestManager {
    func perform<T: Decodable>(_ request: Request) async throws -> T
}

public struct HttpRequestManagerImpl: HttpRequestManager {
    let apiManager: APIManager
    let parser: DataParser
    
    func perform<T: Decodable>(_ request: Request) async throws -> T {
        let (data, response) = try await apiManager.perform(request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        switch response.statusCode {
            case (200...299):
                let entity: T = try await parser.parse(data)
            return entity
            case (400...599):
            throw NetworkError.error(statusCode: response.statusCode, data: data)
        default:
            throw NetworkError.invalidStatusCode(statusCode: response.statusCode)
        }
    }
}
