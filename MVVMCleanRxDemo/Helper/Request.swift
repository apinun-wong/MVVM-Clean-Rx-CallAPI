//
//  Request.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 8/8/2566 BE.
//

import Foundation

public enum RequestMethod: String {
    case GET
    case POST
    case DELETE
}

protocol Request {
    var host: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var params: Encodable? { get }
    var urlParams: Encodable? { get }
    var ignoreCache: Bool { get }
    var method: RequestMethod { get }
}
