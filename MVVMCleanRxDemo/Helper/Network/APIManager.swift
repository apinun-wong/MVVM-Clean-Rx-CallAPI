//
//  APIManager.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 9/8/2566 BE.
//

import Foundation

protocol APIManager {
    func perform(_ request: Request) async throws -> (Data, URLResponse)
}

class APIManagerImpl: APIManager {
    func perform(_ request: Request) async throws -> (Data, URLResponse) {
        let urlRequest = request.createUrlRequest()
        let response = try await URLSession.shared.data(for: urlRequest)
        return response
    }
}
