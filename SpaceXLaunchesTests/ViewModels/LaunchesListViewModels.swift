//
//  LaunchesListViewModels.swift
//  SpaceXLaunches_Tests
//
//  Created by . on 7/19/23.
//

import XCTest
import Combine
@testable import SpaceXLaunches

final class LaunchesListViewModels: XCTestCase {
    
    //MARK: -Properteis
    private var cancellableSet : Set<AnyCancellable> = []
    private var mock_LaunchesService : MockLaunchesService!
    private var launchesListViewModel : LaunchesListView.ViewModel!
    
    //MARK: init and deinit
    override func setUp() {
        mock_LaunchesService = MockLaunchesService()
        launchesListViewModel = .init(launchesService: mock_LaunchesService)
    }

    override func tearDown() {
        
    }
    

    //MARK: - Tests
    
    func test_LauhcnesViewModelWith10MockData() {
        let mockTestData = LaunchModel.mockData
        
        mock_LaunchesService.mockLaunchesResponse = .success(mockTestData)
        launchesListViewModel.launchesService = mock_LaunchesService
        launchesListViewModel.fetchLaunches()
        
        let predicate = NSPredicate { viewModel,_ in
            switch (viewModel as? LaunchesListView.ViewModel)?.fetchedLaunches {
            case .success(let list):
                return list.count > 0
            case .failure(_), .none:
                return false
            }
        }
        let exp = XCTNSPredicateExpectation(predicate: predicate, object: launchesListViewModel)
        wait(for: [exp], timeout: 2)
        switch launchesListViewModel.fetchedLaunches {
        case .success(let list):
            XCTAssertEqual(list, mockTestData)
        case .failure(let error):
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    //TODO: Write more tests to support all scenarios.
}
