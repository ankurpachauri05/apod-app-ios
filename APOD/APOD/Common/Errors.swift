//
//  Errors.swift
//  APOD
//
//  Created by Pachauri, Ankur on 16/06/23.
//

import Foundation

// MARK: RequestError
enum RequestError: Error {
    case invalidURL
    case emptyResponse
    case unexpectedStatusCode(code: Int)
    case unauthorized
}

// MARK: CustomError
enum CustomError: Error {
    case noInternet
}
