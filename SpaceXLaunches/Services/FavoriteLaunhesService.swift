//
//  FavoriteLaunhesService.swift
//  SpaceXLaunches
//
//  Created by Amin on 7/20/23.
//

import Foundation
import Combine

//MARK: - FavoriteLaunches Service
class FavoriteLaunhesService: ObservableObject, Codable {
    
    //MARK: - Properties
    @Published var favoritedList : Array<String> = []
    
    var jsonData: Data? {
        get { try? encoder.encode(favoritedList) }
        set {
            guard let data = newValue,
                  let model = try? decoder.decode([String].self, from: data)
            else { return }
            favoritedList = model
        }
    }
    
    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 3, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    enum CodingKeys: String, CodingKey {
        case favoritedList
    }
    
    //MARK: - Initializations
    internal init(favoritedList: Array<String> = []) {
        self.favoritedList = favoritedList
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let items = try container.decodeIfPresent(
            [String].self, forKey: .favoritedList) {
            self.favoritedList = items
        }
    }
    
    //MARK: - Methods
    func updateState(for item: String) {
        
        if favoritedList.contains(item) {
            favoritedList.removeAll(where: {$0 == item})
        } else {
            favoritedList.append(item)
        }
         
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(favoritedList, forKey: .favoritedList)
    }

}
