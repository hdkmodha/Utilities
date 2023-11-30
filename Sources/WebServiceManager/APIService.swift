//
//  APIService.swift
//
//
//  Created by Hardik Modha on 30/11/23.
//

import Foundation

public protocol APIService {
    var base: String { get }
    var scheme: String { get }
    var fixed: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var url: URL? { get }
}
