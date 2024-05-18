//
//  MockDataModels.swift
//  SpaceXLaunches_Tests
//
//  Created by . on 7/19/23.
//

import Foundation
@testable import SpaceXLaunches_

extension LaunchModel {
    static var mockData : [LaunchModel] {
        [LaunchModel(id: UUID().uuidString,
                     name: "name",
                     flight_number: 1234,
                     upcoming: false,
                     date_utc: "2009-07-13T03:35:00.000Z",
                     date_local: "2009-07-13T15:35:00+12:00",
                     links: nil)
        ]
    }
}


extension LaunchWebRepository.QueryResponseModel {
    static var mockData : LaunchWebRepository.QueryResponseModel {
        .init(docs: [LaunchModel.mockData.first!],
              totalDocs: 10,
              limit: 10,
              totalPages: 1,
              page: 1,
              pagingCounter: 1,
              hasPrevPage: false,
              hasNextPage: false)
    }
}
