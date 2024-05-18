//
//  LaunchesService.swift
//  SpaceXLaunches
//
//  Created by Amin on 7/19/23.
//

import Foundation
import Combine
import SwiftUI

protocol LaunchesServiceProtocol {
    func fetchLaunches(pageNo: Int, withLimit limit: Int, offset: Int) -> AnyPublisher<[LaunchModel], Error>
}

struct LaunchesService {
    var webReposotiry : LaunchWebRepositoryProtocol
}

extension LaunchesService: LaunchesServiceProtocol {
    
    func fetchLaunches(pageNo: Int, withLimit limit: Int, offset: Int = 0) -> AnyPublisher<[LaunchModel], Error> {
        
        //FIXME: SpaceXAPI with `offset` in input may behave improper!! SO it is not passed
        return webReposotiry.fetchLaunches(pageNo: pageNo, withLimit: limit, offset: nil)
            .map { response in
                response.docs
            }
            .eraseToAnyPublisher()
    }
}

extension LaunchesService {
    enum ServiceError: Error {
        case noMoreDataIsAvailable
        
        var localizedDescription: String? {
            switch self {
            case .noMoreDataIsAvailable: return "No more data is available."
            }
        }
    }
}

extension LaunchesService.ServiceError: LocalizedError {
    var errorDescription: String? { localizedDescription }
}
