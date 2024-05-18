//
//  FavoriteLaunchesServiceTests.swift
//  SpaceXLaunches_Tests
//
//  Created by . on 7/20/23.
//

import XCTest
@testable import SpaceXLaunches_


final class FavoriteLaunchesServiceTests: XCTestCase {

    //MARK: - Parameters
    var favoriteService : FavoriteLaunhesService!
    
    
    //MARK: - init and deinit
    override func setUpWithError() throws {
        favoriteService = FavoriteLaunhesService()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Tests for `updateState(for:)`
    func test_AddTenItemsInFavorite_ThenRemoveThem_FavListSuccessfullyUpdated() {
    
        var mockIDs : Array<String> = []
        
        (0...10).forEach{_ in mockIDs.append(UUID().uuidString)}
        
        //Adding
        mockIDs.forEach {
            favoriteService.updateState(for: $0)
            XCTAssert(favoriteService.favoritedList.contains($0))
        }
        
        //Removing
        mockIDs.forEach {
            favoriteService.updateState(for: $0)
            XCTAssert(!favoriteService.favoritedList.contains($0))
        }
    }
    
    //MARK: - Tests for `objectWillChangeSequence`
    
    
    //MARK: - Tests for `jsonData`
    
}
