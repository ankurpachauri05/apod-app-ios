//
//  AstronomyPictureDataRepository.swift
//  APOD
//
//  Created by Pachauri, Ankur on 20/06/23.
//

import Foundation
import CoreData


protocol AstronomyPictureRepositoryProtocol {
    static func addFavorite(data: AstronomyPicture)
    static func getAllFavorite() -> [AstronomyPicture]?
    static func getFavorite(byDate date: String) -> AstronomyPicture?
    static func deleteFavorite(byDate date: String) -> Bool
    static func deleteAllRecords()
}

struct AstronomyPictureDataRepository : AstronomyPictureRepositoryProtocol {
    static func addFavorite(data: AstronomyPicture) {
        let cdAstronomyPicture = CDAstronomyPicture(context: PersistentStorage.shared.context)
        cdAstronomyPicture.date = data.date
        cdAstronomyPicture.explanation = data.explanation
        cdAstronomyPicture.hdurl = data.hdurl
        cdAstronomyPicture.mediaType = data.mediaType.rawValue
        cdAstronomyPicture.title = data.title
        cdAstronomyPicture.url = data.url
        
        PersistentStorage.shared.saveContext()
    }

    static func getAllFavorite() -> [AstronomyPicture]? {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDAstronomyPicture.self)

        var pictures : [AstronomyPicture] = []

        result?.forEach({ cdAstronomyPicture in
            pictures.append(cdAstronomyPicture.convertToAstronomyPicture())
        })

        return pictures
    }

    static func getFavorite(byDate date: String) -> AstronomyPicture? {
        let result = getCDAstronomyPicture(byDate: date)
        guard let result = result else { return nil }
        return result.convertToAstronomyPicture()
    }

    static func deleteFavorite(byDate date: String) -> Bool {
        let cdAstronomyPicture = getCDAstronomyPicture(byDate: date)
        guard let cdAstronomyPicture = cdAstronomyPicture else { return false }

        PersistentStorage.shared.context.delete(cdAstronomyPicture)
        PersistentStorage.shared.saveContext()
        return true
    }

    private static func getCDAstronomyPicture(byDate date: String) -> CDAstronomyPicture? {
        let fetchRequest = NSFetchRequest<CDAstronomyPicture>(entityName: "CDAstronomyPicture")
        let predicate = NSPredicate(format: "date==%@", date as CVarArg)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else { return nil }

            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }

    static func deleteAllRecords() {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = PersistentStorage.shared.context

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDAstronomyPicture")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try privateContext.execute(batchDeleteRequest)
            try privateContext.save()

            PersistentStorage.shared.context.performAndWait {
                do {
                    try PersistentStorage.shared.context.save()
                } catch {
                    // Handle error
                    print("Error saving main context: \(error.localizedDescription)")
                }
            }
        } catch {
            // Handle error
            print("Error deleting records: \(error.localizedDescription)")
        }
    }

}
