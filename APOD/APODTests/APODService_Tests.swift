//
//  APODService_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 28/06/23.
//

import XCTest
@testable import APOD

final class APODService_Tests: XCTestCase {

    func test_getPictureOfDay_With_EmptyDateString_Returns_Failure() {
        Task {
            // ARRANGE
            let date = ""
            
            // ACT
            let result = try await APODService.getPictureOfDay(date: date)
            
            // ASSERT
            XCTAssertThrowsError(RequestError.unexpectedStatusCode(code: 501))
        }
    }
    
    func test_getPictureOfDay_With_InvalidDateString_Returns_Failure() {
        Task {
            // ARRANGE
            let date = "June 28, 2023"  // expected format is yyyy-MM-dd
            
            // ACT
            let result = try await APODService.getPictureOfDay(date: date)
            
            // ASSERT
            XCTAssertThrowsError(RequestError.unexpectedStatusCode(code: 400))
        }
    }
    
    func test_getPictureOfDay_With_ValidDateString_Returns_Success() {
        Task {
            // ARRANGE
            let date = "2023-06-28"
            
            // ACT
            let result = try await APODService.getPictureOfDay(date: date)
            
            // ASSERT
            XCTAssertNoThrow(RequestError.emptyResponse)
            XCTAssertNoThrow(RequestError.unauthorized)
            XCTAssertNoThrow(RequestError.unexpectedStatusCode(code: 400))
            XCTAssertNoThrow(RequestError.unexpectedStatusCode(code: 501))
        }
    }

}
