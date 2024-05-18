//
//  SpaceXLaunchesApp.swift
//  SpaceXLaunches
//
//  Created by . on 5/18/24.
//

import SwiftUI

@main
struct SpaceXLaunchesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(favoritesService: FavoriteLaunhesService())
        }
    }
}
