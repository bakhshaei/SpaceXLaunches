//
//  MockLaunchesService.swift
//  SpaceXLaunches_Tests
//
//  Created by . on 7/19/23.
//

import Foundation
import Combine
@testable import SpaceXLaunches_

struct MockLaunchesService: LaunchesServiceProtocol {
    
    
    var mockLaunchesResponse : Result<[LaunchModel], Error> = .failure(MockError.valueNotSet)
    
    mutating func udpateMock(with data: Result<[LaunchModel], Error>) {
        mockLaunchesResponse = data
    }
    
    func fetchLaunches(pageNo: Int, withLimit limit: Int, offset: Int) -> AnyPublisher<[LaunchModel], Error> {
        mockLaunchesResponse
            .publisher
            .delay(for: .milliseconds(100), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
