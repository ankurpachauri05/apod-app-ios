//
//  CDAstronomyPicture+CoreDataProperties.swift
//  APOD
//
//  Created by Pachauri, Ankur on 20/06/23.
//
//

import Foundation
import CoreData


extension CDAstronomyPicture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAstronomyPicture> {
        return NSFetchRequest<CDAstronomyPicture>(entityName: "CDAstronomyPicture")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var mediaType: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

    func convertToAstronomyPicture() -> AstronomyPicture {
        return .init(date: date ?? "", explanation: explanation ?? "", hdurl: hdurl, mediaType: MediaType(rawValue: mediaType ?? "") ?? .image, title: title ?? "", url: url ?? "")
    }
}

extension CDAstronomyPicture : Identifiable {

}
