//
//  RESTRequestProtocol.swift
//  APOD
//
//  Created by Pachauri, Ankur on 13/06/23.
//

import Foundation

enum RequestType: String {
    case get = "GET"
}

protocol RESTRequestProtocol {
    var host: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var urlParams: [String: String]? { get }
    var requestType: RequestType { get }
}

extension RESTRequestProtocol {
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if let urlParams = urlParams, !urlParams.isEmpty {
            components.queryItems = urlParams.map({ URLQueryItem(name: $0, value: $1) })
        }
        
        guard let url = components.url else { throw RequestError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if let headers = headers, !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let params = params, !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}
