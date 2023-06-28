//
//  FavouritesViewModel_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 28/06/23.
//

import XCTest
@testable import APOD

final class FavouritesViewModel_Tests: XCTestCase {

    func test_getAllFavouritesData_With_NoLocalFavouritesData_Returns_EmptyArray() {
        // ARRANGE
        let viewModel = FavouritesViewModel()
        
        // ACT
        viewModel.getAllFavouritesData()
        
        // ASSERT
        XCTAssertTrue(viewModel.data.isEmpty)
    }
    
    func test_getAllFavouritesData_With_LocalFavouritesData_Returns_NonEmptyArray() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        let viewModel = FavouritesViewModel()
        
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ACT
        viewModel.getAllFavouritesData()
        
        // ASSERT
        XCTAssertFalse(viewModel.data.isEmpty)
    }
    
    func test_deleteFavourite_With_NoLocalFavouritesData_Returns_Success() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        let viewModel = FavouritesViewModel()
        
        // ACT
        viewModel.deleteFavourite(data)
        
        // ASSERT
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }
    
    func test_deleteFavourite_With_LocalFavouritesData_Returns_Success() {
        // ARRANGE
        let data = AstronomyPicture.mockData()
        let viewModel = FavouritesViewModel()
        
        AstronomyPictureDataRepository.addFavorite(data: data)
        
        // ACT
        viewModel.deleteFavourite(data)
        
        // ASSERT
        XCTAssertNil(AstronomyPictureDataRepository.getFavorite(byDate: data.date))
    }

}
