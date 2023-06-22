//
//  APODRequests.swift
//  APOD
//
//  Created by Pachauri, Ankur on 14/06/23.
//

import Foundation


enum APODRequests: RESTRequestProtocol {
    case pictureInRange(String, String)
    case pictureForDate(String)
    
    private struct Constants {
        static let hostURL = "api.nasa.gov"
        
        // Endpoints...
        static let apodPath = "/planetary/apod"
        
        // Param Keys...
        static let dateKey = "date"
        static let startDateKey = "start_date"
        static let endDateKey = "end_date"
        static let thumbsKey = "thumbs"
        static let apiKey = "api_key"
        
        // Param Values...
        static let apiKeyValue = "qxwrYpF4EMbHxEqgMd8AbWf07Uj2xUvXBcK2jMm8"
    }
    
    var host: String {
        return Constants.hostURL
    }
    
    var path: String {
        switch self {
        case .pictureInRange(_, _), .pictureForDate(_):
            return Constants.apodPath
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var params: [String : Any]? {
        nil
    }
    
    var urlParams: [String : String]? {
        switch self {
        case .pictureInRange(let startDate, let endDate):
            return [
                Constants.startDateKey: startDate,
                Constants.endDateKey: endDate,
                Constants.apiKey: Constants.apiKeyValue
            ]
        case .pictureForDate(let date):
            return [
                Constants.dateKey: date,
                Constants.apiKey: Constants.apiKeyValue
            ]
        }
    }
    
    var requestType: RequestType {
        .get
    }
    
}
