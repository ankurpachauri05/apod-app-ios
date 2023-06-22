//
//  RESTNetworkService.swift
//  APOD
//
//  Created by Pachauri, Ankur on 13/06/23.
//

import Foundation

protocol RESTNetworkServiceProtocol {
    static func run<T: Decodable>(_ request: RESTRequestProtocol, responseModel: T.Type) async throws -> T
}

struct RESTNetworkService: RESTNetworkServiceProtocol {
    static func run<T>(_ request: RESTRequestProtocol, responseModel: T.Type) async throws -> T where T : Decodable {
        do {
            let urlRequest = try request.createURLRequest()
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else { throw RequestError.invalidURL }
            
            switch response.statusCode {
            case 200...299:
                let parseableData = !data.isEmpty ? data: "{}".data(using: .utf8)!
                let decodedResponse = try JSONDecoder().decode(T.self, from: parseableData)
                
                return decodedResponse
            case 401:
                throw RequestError.unauthorized
            default:
                throw RequestError.unexpectedStatusCode(code: response.statusCode)
            }
        } catch {
            throw error
        }
    }
    
}
