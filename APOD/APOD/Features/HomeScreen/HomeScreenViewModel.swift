//
//  HomeScreenViewModel.swift
//  APOD
//
//  Created by Pachauri, Ankur on 14/06/23.
//

import Foundation

class HomeScreenViewModel: ObservableObject {
    
    @Published var requestState: RequestState<AstronomyPicture> = .undefined
    @Published var isFavourite: Bool = false
    
    @MainActor
    func getAstronomyPictureOfDay(_ date: String) async {
        guard !date.isEmpty else {
            requestState = .failure(CustomError.emptyDateString)
            return
        }
        
        if let data: AstronomyPicture = try? CacheManager.shared.cachedValue(forKey: date) {
            // data already exist in cache..
            requestState = .success(data)
        } else {
            if Reachability.hasInternetConnection() {
                do {
                    requestState = .loading
                    let data = try await APODService.getPictureOfDay(date: date)
                    requestState = .success(data)
                    
                    checkIfFavourite(data)
                    try? CacheManager.shared.cacheValue(data, forKey: data.date)
                } catch {
                    requestState = .failure(error)
                }
            } else {
                // No Internet connection...
                
                requestState = .failure(CustomError.noInternet)
            }
        }
    }
    
    func addRemoveFavourite() {
        if let data = requestState.value {
            if isFavourite {
                _ = AstronomyPictureDataRepository.deleteFavorite(byDate: data.date)
            } else {
                AstronomyPictureDataRepository.addFavorite(data: data)
            }
            
            isFavourite.toggle()
        }
    }
    
    private func checkIfFavourite(_ data: AstronomyPicture) {
        isFavourite = AstronomyPictureDataRepository.getFavorite(byDate: data.date) != nil
    }
}

