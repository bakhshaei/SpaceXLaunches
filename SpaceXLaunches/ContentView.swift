//
//  ContentView.swift
//  SpaceXLaunches
//
//  Created by . on 5/18/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var favoritesService : FavoriteLaunhesService
    @AppStorage("favoritedItems") private var storedFavorites: Data?
    
    var body: some View {
        NavigationStack {
            LaunchesListView(
                viewModel: .init(
                    launchesService:
                        LaunchesService(
                            webReposotiry: LaunchWebRepository(session: .shared)
                        )
                )
            )
        }
        .environmentObject(favoritesService)
        .task {
            if let jsonData = storedFavorites {
                favoritesService.jsonData = jsonData
            }
            for await _ in favoritesService.objectWillChangeSequence {
                storedFavorites = favoritesService.jsonData
            }
        }
    }
}

#Preview {
    ContentView(favoritesService: FavoriteLaunhesService())
}
