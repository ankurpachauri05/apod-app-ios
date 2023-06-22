//
//  APODApp.swift
//  APOD
//
//  Created by Pachauri, Ankur on 13/06/23.
//

import SwiftUI

@main
struct APODApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreenView(viewModel: .init())
        }
    }
}
