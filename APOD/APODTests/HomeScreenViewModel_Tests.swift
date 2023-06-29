//
//  HomeScreenViewModel_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 28/06/23.
//

import XCTest
@testable import APOD

final class HomeScreenViewModel_Tests: XCTestCase {
    var sut: HomeScreenViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = HomeScreenViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func test_getAstronomyPictureOfDay_With_EmptyDateString_Returns_Failure() async {
        // ARRANGE
        let date = ""
        
        // ACT
        await sut.getAstronomyPictureOfDay(date)
        
        // ASSERT
        XCTAssertTrue(sut.requestState.isFailure)
        XCTAssertNotNil(sut.requestState.error)
    }
    
    func test_getAstronomyPictureOfDay_With_InvalidDateString_Returns_Failure() async {
        // ARRANGE
        let date = "June 20, 2023"  // Valid format is yyyy-MM-dd
        
        // ACT
        await sut.getAstronomyPictureOfDay(date)
        
        // ASSERT
        XCTAssertTrue(sut.requestState.isFailure)
        XCTAssertNotNil(sut.requestState.error)
    }
    
    func test_getAstronomyPictureOfDay_With_ValidDateString_Returns_Success() async {
        // ARRANGE
        let date = "2023-06-28"
        
        // ACT
        await sut.getAstronomyPictureOfDay(date)
        
        // ASSERT
        XCTAssertTrue(sut.requestState.isSuccess)
        XCTAssertNotNil(sut.requestState.value)
    }
    
    func test_addRemoveFavourite_With_NoPictureDataAndIsFavouriteFalse_Returns_IsFavouriteFalse() {
        // ARRANGE
        sut.requestState = .failure(CustomError.noInternet)
        sut.isFavourite = false
        
        // ACT
        sut.addRemoveFavourite()
        
        // ASSERT
        XCTAssertFalse(sut.isFavourite)
    }
    
    func test_addRemoveFavourite_With_NoPictureDataAndIsFavouriteTrue_Returns_IsFavouriteTrue() {
        // ARRANGE
        sut.requestState = .failure(CustomError.noInternet)
        sut.isFavourite = true
        
        // ACT
        sut.addRemoveFavourite()
        
        // ASSERT
        XCTAssertTrue(sut.isFavourite)
    }
    
    func test_addRemoveFavourite_With_PictureDataAndIsFavouriteFalse_Returns_IsFavouriteTrue() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        sut.requestState = .success(data)
        sut.isFavourite = false
        
        // ACT
        sut.addRemoveFavourite()
        
        // ASSERT
        XCTAssertTrue(sut.isFavourite)
        XCTAssertNotNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }
    
    func test_addRemoveFavourite_With_PictureDataAndIsFavouriteTrue_Returns_IsFavouriteFalse() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        
        sut.requestState = .success(data)
        sut.isFavourite = true
        
        // ACT
        sut.addRemoveFavourite()
        
        // ASSERT
        XCTAssertFalse(sut.isFavourite)
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }

}
