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
    
    static func mockData() -> AstronomyPicture {
        return .init(date: "2023-06-28", explanation: "Sample explanation", hdurl: "https://picsum.photos/200/300", mediaType: .image, title: "Sample Title", url: "https://picsum.photos/200/300")
    }
}
