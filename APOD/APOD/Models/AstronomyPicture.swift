//
//  AstronomyPicture.swift
//  APOD
//
//  Created by Pachauri, Ankur on 14/06/23.
//

import Foundation

struct AstronomyPicture: Codable {
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: MediaType
    let title: String
    let url: String
}

extension AstronomyPicture {
    static func placeholderData() -> AstronomyPicture {
        return .init(date: "2023-06-09", explanation: "Sample Explanation", hdurl: "https://picsum.photos/200/300", mediaType: .image, title: "Astronomy Picture", url: "https://picsum.photos/200/300")
    }
}
