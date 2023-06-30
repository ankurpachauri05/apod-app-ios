//
//  APODService_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 28/06/23.
//

import XCTest
@testable import APOD

final class APODService_Tests: XCTestCase {

    func test_getPictureOfDay_With_EmptyDateString_Returns_Failure() async {
        // ARRANGE
        let date = ""
        var thrownError: Error?
        
        // ACT
        do {
            _ = try await APODService.getPictureOfDay(date: date)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
    }
    
    func test_getPictureOfDay_With_InvalidDateString_Returns_Failure() async {
        // ARRANGE
        let date = "June 28, 2023"  // expected format is yyyy-MM-dd
        var thrownError: Error?
        
        // ACT
        do {
            _ = try await APODService.getPictureOfDay(date: date)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? RequestError, .unexpectedStatusCode(code: 400))
    }
    
    func test_getPictureOfDay_With_ValidDateString_Returns_Success() async {
        // ARRANGE
        let date = "2023-06-28"
        var thrownError: Error?
        
        // ACT
        do {
            _ = try await APODService.getPictureOfDay(date: date)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
    }

}
