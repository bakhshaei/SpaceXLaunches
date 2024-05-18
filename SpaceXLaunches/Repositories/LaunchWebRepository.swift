//
//  LaunchWebRepository.swift
//  SpaceXLaunches_Snapp
//
//  Created by Amin on 7/18/23.
//

import Foundation
import Combine

protocol LaunchWebRepositoryProtocol {
    var session: URLSession { get }
    var baseURL: String { get }
    var queue: DispatchQueue { get }
    
    //func fetchLaunches(fromBeginning: Bool) -> AnyPublisher<[LaunchModel], Error>
    func fetchLaunches(pageNo: Int, withLimit limit: Int, offset: Int?) -> AnyPublisher<LaunchWebRepository.QueryResponseModel, Error>
}


class LaunchWebRepository: LaunchWebRepositoryProtocol {
    
    //MARK: - Properties
    let session: URLSession
    let baseURL: String = "https://api.spacexdata.com"
    let queue = DispatchQueue(label: "background_queue")
    
    init(session: URLSession) {
        self.session = session
    }
    
    //MARK: - Methods
    
    /*
    /// Fetch Launches from the API.
    /// - Parameter fromBeginning: if this parameter sets as `true`, the page counter reset. Otherwise it will fetch data for the next peage. Default value is `false`
    func fetchLaunches(fromBeginning: Bool = false) -> AnyPublisher<[LaunchModel], Error> {
        let request = QueryRequestModel(query: nil,
                                        options: .init(page: 1, limit: 10))
        
        let response : AnyPublisher<QueryResponseModel, Error> = call(endpoint: QueryAPI.fetch(request))
        return response
            .map { response in
                //response.docs
                return []
            }
            .eraseToAnyPublisher()
    }
     */
    
    /// Fetch Launches from the API the for specific parameters. For more information please visit API's documentation.
    /// - Parameters:
    ///   - pageNo: Page number to fetch.
    ///   - limit: Limits
    ///   - offset: item's offset
    /// - Returns: Retrieved response.
    /// - Warning: SpaceX's API with `offset` in input may behave improper!!
    func fetchLaunches(pageNo: Int,
                       withLimit limit: Int,
                       offset: Int? = nil ) -> AnyPublisher<QueryResponseModel, Error> {
        
        let request = QueryRequestModel(query: nil,
                                        options: .init(page: pageNo, offset: offset, limit: limit))
        
        return call(endpoint: QueryAPI.fetch(request))
    }
}


extension LaunchWebRepository {
    func call<Value>(endpoint: WebAPI, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
        where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: URL(string: baseURL))
            Task {
                let a = try await session.download(for: request)
            }
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}


//MARK: - Query Request Model
extension LaunchWebRepository {
    struct QueryRequestModel: Codable {
        var query: LaunchModel?
        var options: Options?
    }
}

extension LaunchWebRepository.QueryRequestModel {
    struct Options: Codable {
        var page: Int
        var offset: Int?
        var limit: Int
    }
}

//MARK: - Query Resposne Model
extension LaunchWebRepository {
    struct QueryResponseModel: Codable {
        var docs: Array<LaunchModel>
        var totalDocs: Int
        var limit: Int
        var totalPages: Int
        var page: Int
        var pagingCounter: Int
        var hasPrevPage: Bool
        var hasNextPage: Bool
        var prevPage: Int?
        var nextPage: Int?
    }
}
//MARK: - Equatable
extension LaunchWebRepository.QueryResponseModel : Equatable { }


//MARK: - Query API
extension LaunchWebRepository {
    enum QueryAPI/*_v5*/ {
        case fetch(_ query: QueryRequestModel)
    }
}

extension LaunchWebRepository.QueryAPI: WebAPI {
    
    var endpoint: String { "/v5/launches/query" }
    
    var method: String { "POST" }
    
    var headers: [String: String]? {
        ["Content-Type" : "application/json"]
    }
    
    func body() throws -> Data? {
        switch self {
        case .fetch(let reqQuery):
            return try JSONEncoder().encode(reqQuery)
        }
    }
}
