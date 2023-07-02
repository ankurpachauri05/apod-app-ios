//
//  AstronomyPictureDataRepository_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 29/06/23.
//

import XCTest
@testable import APOD

final class AstronomyPictureDataRepository_Tests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        AstronomyPictureDataRepository.deleteAllRecords()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_addFavorite_With_PictureData_SavesDataLocally() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        // ACT
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ASSERT
        XCTAssertNotNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }
    
    func test_getAllFavorite_With_NoPicturesDataInLocal_Returns_EmptyArray() {
        // ARRANGE
        
        
        // ACT
        let result = AstronomyPictureDataRepository.getAllFavorite()
        
        // ASSERT
        XCTAssertEqual(result?.isEmpty, true)
    }
    
    func test_getAllFavorite_With_PicturesDataInLocal_Returns_NonEmptyArray() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ACT
        let result = AstronomyPictureDataRepository.getAllFavorite()
        
        // ASSERT
        XCTAssertEqual(result?.isEmpty, false)
    }
    
    func test_getFavorite_With_NoPictureDataInLocal_Returns_Nil() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        // ACT
        let result = AstronomyPictureDataRepository.getFavorite(byDate: data.date)
        
        // ASSERT
        XCTAssertNil(result)
    }
    
    func test_getFavorite_With_PicturesDataInLocal_Returns_PictureData() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ACT
        let result = AstronomyPictureDataRepository.getFavorite(byDate: data.date)
        
        // ASSERT
        XCTAssertNotNil(result)
    }
    
    func test_deleteFavorite_With_NoPicturesDataInLocal_Returns_Success() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        // ACT
        let result = AstronomyPictureDataRepository.deleteFavorite(byDate: data.date)
        
        // ASSERT
        XCTAssertFalse(result)
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }
    
    func test_deleteFavorite_With_PicturesDataInLocal_Returns_Success() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ACT
        let result = AstronomyPictureDataRepository.deleteFavorite(byDate: data.date)
        
        // ASSERT
        XCTAssertTrue(result)
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }

}
