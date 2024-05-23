//
//  LaunchesListView.swift
//  SpaceXLaunches
//
//  Created by . on 7/19/23.
//

import SwiftUI

struct LaunchesListView: View {
    
    @EnvironmentObject var favoritesService : FavoriteLaunhesService
    @StateObject var viewModel : ViewModel
    
    var body: some View {
        List {
            launchesList
            
            if !viewModel.isFiltered &&
                viewModel.hasNextPage {
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
        
        .toolbar {
            ///Filter Button
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.isFiltered.toggle()
                }, label: {
                    Label("", systemImage: viewModel.isFiltered ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                })
            }
        }
    
    }
    
    @ViewBuilder private var launchesList : some View {
        switch viewModel.fetchedLaunches {
        case .success(let launches):
            let listItems :Array<LaunchModel> = viewModel.isFiltered ? launches.filter({favoritesService.favoritedList.contains($0.id)}) : launches
            
            ForEach(listItems) { item in
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


struct LaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LaunchesListView(viewModel: .init(launches: LaunchModel.preview,
                                              launchesService: LaunchesService(webReposotiry: LaunchWebRepository(session: .shared)) ))
        }
        .environmentObject(FavoriteLaunhesService())
    }
}


