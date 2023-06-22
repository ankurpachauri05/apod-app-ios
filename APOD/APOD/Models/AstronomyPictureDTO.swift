//
//  AstronomyPictureDTO.swift
//  APOD
//
//  Created by Pachauri, Ankur on 14/06/23.
//

import Foundation

struct AstronomyPictureDTO: Decodable {
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: MediaType
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case title
        case url
    }
}

enum MediaType: String, Codable {
    case image = "image"
    case video = "video"
}

extension AstronomyPictureDTO {
    func toDomain() -> AstronomyPicture {
        return .init(date: date, explanation: explanation, hdurl: hdurl, mediaType: mediaType, title: title, url: url)
    }
}
