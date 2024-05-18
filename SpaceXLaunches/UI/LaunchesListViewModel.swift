//
//  LaunchesListViewModel.swift
//  SpaceXLaunches_Snapp
//
//  Created by Amin on 7/19/23.
//

import Foundation
import Combine

extension LaunchesListView {
    
    
    class ViewModel: ObservableObject {
        
        //MARK: - Properties
        @Published var hasNextPage : Bool = true
        @Published var fetchedLaunches : Result<Array<LaunchModel>, Error>
        
        var launchesService : LaunchesServiceProtocol
        private var cancellableSet : Set<AnyCancellable> = []
        
        private var currentPage : Int  = 0
        private var pageLimit   : Int {
            currentPage == 0 ? 20 : 50
        }
        private var itemOffset  : Int {
            currentPage == 0 ? 0 : 20
        }
        
        
        
        //MARK: - Initializer
        init(launches: Array<LaunchModel> = [],
             launchesService: LaunchesServiceProtocol) {
            self.fetchedLaunches = .success(launches)
            self.launchesService = launchesService
        }
        
        
        //MARK: - Methods
        
        func fetchLaunches(refresh shouldRefresh: Bool = false) {
            if shouldRefresh {
                fetchedLaunches = .success([])
                currentPage = 0
                hasNextPage = true
            }
            
            //Check if the next page is exiseted.
            guard hasNextPage else { return }
            
            launchesService.fetchLaunches(pageNo: currentPage + 1, withLimit: pageLimit, offset: 0)
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
                    case.finished:
                        print("\t>[\(#function)] completed!")
                    case .failure(let error):
                        Task {
                            //Update list to present fail scenario
                            await self.updateList(with: .failure(error), hasNextPage: false)
                        }
                    }
                } receiveValue: { items in
                    Task(priority: .userInitiated) {
                            switch self.fetchedLaunches {
                            case .success(var lanchesList):
                                //The list existed [`launchesList`]. Try to append received items to that.
                                
                                var newItemReceived: Bool = false
                                items.forEach { item in
                                    
                                    //Make sure the the item is unique. [Prevent duplicate items]
                                    //[Performance need to be improved]
                                    if !lanchesList.contains(where: { $0.id == item.id}) {
                                        lanchesList.append(item)
                                        newItemReceived = true
                                    }
                                }
                                                                
                                if newItemReceived {
                                    //Set the list with new items.
                                    await self.updateList(with: .success(lanchesList), hasNextPage: true)
                                    self.currentPage += 1
                                } else {
                                    await self.updateList(hasNextPage: false)
                                    //self.hasNextPage = false
                                }
                                
                                
                            case .failure(_):
                                //The list was failed in the last fetch, so fill with with a fresh success list.
                                await self.updateList(with: .success(items))
                                break
                            }
                    }
                }
                .store(in: &cancellableSet)

        }
        
        private func updateList(with launces: Result<Array<LaunchModel>, Error>? = nil,
                                hasNextPage: Bool? = nil) async {
            await MainActor.run {
                if let launces {
                    self.fetchedLaunches = launces
                }
                if let hasNextPage {
                    self.hasNextPage = hasNextPage
                }
            }
        }
        
    }
}
