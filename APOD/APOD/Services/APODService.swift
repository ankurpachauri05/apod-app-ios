//
//  APODService.swift
//  APOD
//
//  Created by Pachauri, Ankur on 14/06/23.
//

import Foundation

struct APODService {
    static func getPictureOfDay(date: String) async throws -> AstronomyPicture {
        let request = APODRequests.pictureForDate(date)
        let result = try await RESTNetworkService.run(request, responseModel: AstronomyPictureDTO.self)
        return result.toDomain()
    }
}
