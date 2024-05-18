//
//  LaunchesListView.swift
//  SpaceXLaunches
//
//  Created by . on 7/19/23.
//

import SwiftUI

struct LaunchesListView: View {
    
    @StateObject var viewModel : ViewModel
    
    var body: some View {
        List {
            launchesList
            
            if viewModel.hasNextPage {
                ProgressView {
                    Text("Loading launches...")
                }
                .task {
                    viewModel.fetchLaunches()
                }
            }
        }
        .navigationTitle("SpaceX launches")
        .refreshable {
            viewModel.fetchLaunches(refresh: true)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Rectangle().foregroundColor(.red))
        .listStyle(.sidebar)
    }
    
    @ViewBuilder private var launchesList : some View {
        switch viewModel.fetchedLaunches {
        case .success(let launches):
            ForEach(launches) { item in
                NavigationLink {
                    LaunchDetailView(item: item)
                } label: {
                    LaunchesListRowView(item: item, imageLoader: .init(url: item.links?.smallPatch))
                }
            }
        case .failure(let error):
            Text("Error occured: \(error.localizedDescription)")
                .font(.title3)
                .foregroundColor(.secondary)
                .frame(alignment: .center)
                .padding()
        }
    }
    
}

/*
struct LaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LaunchesListView(viewModel: .init(launches: LaunchModel.preview,
                                              launchesService: LaunchesService(webReposotiry: LaunchWebRepository(session: .shared)) ))
        }
        .environmentObject(FavoriteLaunhesService())
    }
}

*/
