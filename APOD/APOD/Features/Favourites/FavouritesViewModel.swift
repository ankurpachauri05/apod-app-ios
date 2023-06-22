//
//  FavouritesViewModel.swift
//  APOD
//
//  Created by Pachauri, Ankur on 20/06/23.
//

import Foundation

class FavouritesViewModel: ObservableObject {
    @Published var data: [AstronomyPicture] = []
    
    func getAllFavouritesData() {
        if let picturesData = AstronomyPictureDataRepository.getAllFavorite() {
            data = picturesData
        }
    }
    
    func deleteFavourite(_ data: AstronomyPicture) {
        _ = AstronomyPictureDataRepository.deleteFavorite(byDate: data.date)
        getAllFavouritesData()
    }
}
