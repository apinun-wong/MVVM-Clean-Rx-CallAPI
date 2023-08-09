//
//  Configuration.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 9/8/2566 BE.
//

import Foundation

let scheme: String = "https://"
let domain: String = "64b493620efb99d862691430.mockapi.io"
let baseUrlPath: String = "\(scheme)\(domain)"
var baseUrl: URL {
    return URL(string: baseUrlPath)!
}

