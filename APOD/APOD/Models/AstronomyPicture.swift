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
        return .init(date: "shimmer.dummy.small".localized(), explanation: "shimmer.dummy.large".localized(), hdurl: nil, mediaType: .image, title: "shimmer.dummy.medium".localized(), url: "")
    }
}
