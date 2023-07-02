//
//  FavouritesViewModel_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 28/06/23.
//

import XCTest
@testable import APOD

final class FavouritesViewModel_Tests: XCTestCase {
    var sut: FavouritesViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = FavouritesViewModel()
        AstronomyPictureDataRepository.deleteAllRecords()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func test_getAllFavouritesData_With_NoLocalFavouritesData_Returns_EmptyArray() {
        // ARRANGE
        
        // ACT
        sut.getAllFavouritesData()
        
        // ASSERT
        XCTAssertTrue(sut.data.isEmpty)
    }
    
    func test_getAllFavouritesData_With_LocalFavouritesData_Returns_NonEmptyArray() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ACT
        sut.getAllFavouritesData()
        
        // ASSERT
        XCTAssertFalse(sut.data.isEmpty)
    }
    
    func test_deleteFavourite_With_NoLocalFavouritesData_Returns_Success() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        // ACT
        sut.deleteFavourite(data)
        
        // ASSERT
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }
    
    func test_deleteFavourite_With_LocalFavouritesData_Returns_Success() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ACT
        sut.deleteFavourite(data)
        
        // ASSERT
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }

}
