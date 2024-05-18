//
//  LaunchWebRepositoryTests.swift
//  SpaceXLaunches_Tests
//
//  Created by . on 7/18/23.
//

import XCTest
import Combine
@testable import SpaceXLaunches

final class LaunchWebRepositoryTests: XCTestCase {
    
    //MARK: -Properteis
    private var cancellableSet : Set<AnyCancellable> = []
    private var launchesWebRepo : LaunchWebRepository!
    
    
    //MARK: init and deinit
    override func setUp() {
        launchesWebRepo = LaunchWebRepository(session: .shared)
    }

    override func tearDown() {
        
    }
    
    //MARK: - Test

    func test_FetchLaunches_FirstPage() {
        let exp = XCTestExpectation(description: "Completion")
        launchesWebRepo.fetchLaunches(pageNo: 1, withLimit: 20)
            .sink(receiveCompletion: {_ in}, receiveValue: { response in
                XCTAssert(response.docs.count == 20)
                XCTAssert(response.page == 1)
                exp.fulfill()
            })
            .store(in: &cancellableSet)
            
        wait(for: [exp], timeout: 10)
    }
    
    
    func test_FetchLaunched_SecondPageWith50Items20Offsets() {
        let exp = XCTestExpectation(description: "Completion")
        //FIXME: SpaceX's API with `offset` in input may behave improper!!
        launchesWebRepo.fetchLaunches(pageNo: 2, withLimit: 50, offset: 20)
            .sink(receiveCompletion: {_ in }, receiveValue: { response in
                XCTAssert(response.docs.count == 50)
                //Check `page` parameter in the response for this scenatio.
                //XCTAssert(response.page == 2)
                
                exp.fulfill()
            })
            .store(in: &cancellableSet)
        
        wait(for: [exp], timeout: 10)
    }
    
    func test_FetchLaunched_SecondPageWith50Items() {
        let exp = XCTestExpectation(description: "Completion")
        launchesWebRepo.fetchLaunches(pageNo: 2, withLimit: 50)
            .sink(receiveCompletion: {_ in }, receiveValue: { response in
                XCTAssert(response.docs.count == 50)
                XCTAssert(response.page == 2)
                exp.fulfill()
            })
            .store(in: &cancellableSet)
        
        wait(for: [exp], timeout: 10)
    }
    
    
    //TODO: Write more tests to support complete scenarios.
}
