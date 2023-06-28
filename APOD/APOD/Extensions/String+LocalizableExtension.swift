//
//  String+LocalizableExtension.swift
//  APOD
//
//  Created by Pachauri, Ankur on 27/06/23.
//

import UIKit

extension String {

    /// Swift friendly localization syntax, replaces NSLocalizedString
    public func localized() -> String {
        return localized(tableName: nil, bundle: Bundle.main)
    }

    /**
        Swift friendly localization syntax, replaces NSLocalizedString.
        - parameter tableName: The receiver’s string table to search. If tableName is `nil`
        or is an empty string, the method attempts to use `Localizable.strings`.
        - parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
        the method attempts to use main bundle.
        - returns: The localized string.
     */
    func localized(tableName: String?, bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? Bundle.main
        return bundle.localizedString(forKey: self, value: nil, table: tableName)
    }
    
}

