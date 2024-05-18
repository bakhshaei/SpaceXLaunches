//
//  MockLaunchesWebRepository.swift
//  SpaceXLaunches_Tests
//
//  Created by . on 7/19/23.
//

import Foundation
import Combine
@testable import SpaceXLaunches_

extension URLSession {
    static var mockedResponsesOnly: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
}

struct MockLaunchedWebRepository: LaunchWebRepositoryProtocol {
    
    
    var mockLaunchesResponse: Result<LaunchWebRepository.QueryResponseModel, Error> = .failure(MockError.valueNotSet)

    var session: URLSession = .mockedResponsesOnly
    
    var baseURL: String = "https://UnitTest.com/"
    
    var queue: DispatchQueue = DispatchQueue(label: "unit_test")
    
    func fetchLaunches(pageNo: Int, withLimit limit: Int, offset: Int?) -> AnyPublisher<LaunchWebRepository.QueryResponseModel, Error> {
        Future { promise in
            promise(mockLaunchesResponse)
        }
        .eraseToAnyPublisher()
    }
    
    
}


enum MockError: Error {
    case valueNotSet
}
