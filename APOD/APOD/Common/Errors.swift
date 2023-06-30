//
//  Errors.swift
//  APOD
//
//  Created by Pachauri, Ankur on 16/06/23.
//

import Foundation

// MARK: RequestError
enum RequestError: Error, Equatable {
    case invalidURL
    case emptyResponse
    case unexpectedStatusCode(code: Int)
    case unauthorized
}

// MARK: CustomError
enum CustomError: Error {
    case noInternet
    case emptyDateString
}

// MARK: DirectoryError
enum DirectoryError: Error {
    case containerURLNotFound
    case savingFailed
    case fetchingFailed
    case deletionFailed
}

// MARK: CachingError
enum CachingError: Error {
    case invalidKey
}
