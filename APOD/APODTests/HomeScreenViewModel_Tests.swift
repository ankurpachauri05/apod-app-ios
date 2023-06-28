//
//  HomeScreenViewModel_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 28/06/23.
//

import XCTest
@testable import APOD

final class HomeScreenViewModel_Tests: XCTestCase {

    func test_getAstronomyPictureOfDay_With_EmptyDateString_Returns_Failure() {
        Task {
            // ARRANGE
            let viewModel = HomeScreenViewModel()
            let date = ""
            
            // ACT
            await viewModel.getAstronomyPictureOfDay(date)
            
            // ASSERT
            XCTAssertTrue(viewModel.requestState.isFailure)
            XCTAssertNotNil(viewModel.requestState.error)
            
        }
    }
    
    func test_getAstronomyPictureOfDay_With_InvalidDateString_Returns_Failure() {
        Task {
            // ARRANGE
            let viewModel = HomeScreenViewModel()
            let date = "June 20, 2023"  // Valid format is yyyy-MM-dd
            
            // ACT
            await viewModel.getAstronomyPictureOfDay(date)
            
            // ASSERT
            XCTAssertTrue(viewModel.requestState.isFailure)
            XCTAssertNotNil(viewModel.requestState.error)
            
        }
    }
    
    func test_getAstronomyPictureOfDay_With_ValidDateString_Returns_Success() {
        Task {
            // ARRANGE
            let viewModel = HomeScreenViewModel()
            let date = "2023-06-28"
            
            // ACT
            await viewModel.getAstronomyPictureOfDay(date)
            
            // ASSERT
            XCTAssertTrue(viewModel.requestState.isSuccess)
            XCTAssertNotNil(viewModel.requestState.value)
            
        }
    }
    
    func test_addRemoveFavourite_With_NoPictureDataAndIsFavouriteFalse_Returns_IsFavouriteFalse() {
        // ARRANGE
        let viewModel = HomeScreenViewModel()
        viewModel.requestState = .failure(CustomError.noInternet)
        viewModel.isFavourite = false
        
        // ACT
        viewModel.addRemoveFavourite()
        
        // ASSERT
        XCTAssertFalse(viewModel.isFavourite)
    }
    
    func test_addRemoveFavourite_With_NoPictureDataAndIsFavouriteTrue_Returns_IsFavouriteTrue() {
        // ARRANGE
        let viewModel = HomeScreenViewModel()
        viewModel.requestState = .failure(CustomError.noInternet)
        viewModel.isFavourite = true
        
        // ACT
        viewModel.addRemoveFavourite()
        
        // ASSERT
        XCTAssertTrue(viewModel.isFavourite)
    }
    
    func test_addRemoveFavourite_With_PictureDataAndIsFavouriteFalse_Returns_IsFavouriteTrue() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        let viewModel = HomeScreenViewModel()
        viewModel.requestState = .success(data)
        viewModel.isFavourite = false
        
        // ACT
        viewModel.addRemoveFavourite()
        
        // ASSERT
        XCTAssertTrue(viewModel.isFavourite)
        XCTAssertNotNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }
    
    func test_addRemoveFavourite_With_PictureDataAndIsFavouriteTrue_Returns_IsFavouriteFalse() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        let viewModel = HomeScreenViewModel()
        viewModel.requestState = .success(data)
        viewModel.isFavourite = true
        
        // ACT
        viewModel.addRemoveFavourite()
        
        // ASSERT
        XCTAssertFalse(viewModel.isFavourite)
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }

}
