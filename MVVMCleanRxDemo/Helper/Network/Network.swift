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
}

protocol HttpRequestManager {
    func perform<T: Decodable, E: Decodable>(_ request: Request) async throws -> Result<T, E>
}

public struct HttpRequestManagerImpl: HttpRequestManager {
    let apiManager: APIManager
    let parser: DataParser
    
    func perform<T, E>(_ request: Request) async throws -> Result<T, E> where T : Decodable, E : Decodable, E : Error {
        let (data, response) = try await apiManager.perform(request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        switch response.statusCode {
            case (200...299):
                let entity: T = try await parser.parse(data)
            return Result.success(entity)
            case (400...599):
                let entity: E = try await parser.parse(data)
            return Result.failure(entity)
        default:
            throw NetworkError.invalidStatusCode(statusCode: response.statusCode)
        }
    }
}
