//
//  LaunchesServiceTests.swift
//  SpaceXLaunches_Tests
//
//  Created by . on 7/19/23.
//

import XCTest
import Combine
@testable import SpaceXLaunches_

final class LaunchesServiceTests: XCTestCase {
    
    //MARK: -Properteis
    private var cancellableSet : Set<AnyCancellable> = []
    private var mock_LaunchesWebRepo : MockLaunchedWebRepository!
    private var launchesService : LaunchesService!
    
    
    //MARK: init and deinit
    override func setUpWithError() throws {
        mock_LaunchesWebRepo = MockLaunchedWebRepository()
        launchesService = LaunchesService(webReposotiry: mock_LaunchesWebRepo)
    }

    override func tearDownWithError() throws {
        
    }


    //MARK: - Tests
    func test_LauchServiceWith10MockData() {
        let exp = XCTestExpectation(description: "Completion")
        let mockTestData = LaunchWebRepository.QueryResponseModel.mockData
        
        mock_LaunchesWebRepo.mockLaunchesResponse = .success(mockTestData)
        launchesService.webReposotiry = mock_LaunchesWebRepo
        
        
        launchesService.fetchLaunches(pageNo: 0, withLimit: 0, offset: 0)
            .sink { _ in } receiveValue: { response in
                XCTAssertEqual(response, mockTestData.docs)
                exp.fulfill()
            }
            .store(in: &cancellableSet)
        
        wait(for: [exp], timeout: 4)
    }
    
    
    //TODO: Write more tests to support all scenarios.
}
