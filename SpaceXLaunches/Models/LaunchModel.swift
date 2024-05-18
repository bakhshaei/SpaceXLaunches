//
//  LaunchModel.swift
//  SpaceXLaunches
//
//  Created by . on 7/18/23.
//

import Foundation

struct LaunchModel: Codable {
    var id: String
    var name: String
    var flight_number: Int
    var upcoming: Bool
    var success: Bool?
    var details: String?
    var date_utc: String
    //var date_unix: Date
    var date_local: String
    var links: Links?
}

extension LaunchModel {
    struct Links: Codable {
        var smallPatch: String?
        var largePatch: String?
        var wikipedia: String?
        
        enum CodingKeys: String, CodingKey {
            case patch
            case wikipedia
        }
        
        enum PatchKeys: String, CodingKey {
            case small
            case large
        }
        
    }
}

extension LaunchModel.Links {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        wikipedia = try values.decodeIfPresent(String.self, forKey: .wikipedia)
        let patch = try values.nestedContainer(keyedBy: PatchKeys.self, forKey: .patch)
        smallPatch = try patch.decodeIfPresent(String.self, forKey: .small)
        largePatch = try patch.decodeIfPresent(String.self, forKey: .large)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wikipedia, forKey: .wikipedia)
        
        var patch = container.nestedContainer(keyedBy: PatchKeys.self, forKey: .patch)
        try patch.encode(largePatch, forKey: .large)
        try patch.encode(smallPatch, forKey: .small)
    }
}

//MARK: - Identifiable
extension LaunchModel: Identifiable { }


//MARK: - Equatable
extension LaunchModel.Links: Equatable { }

extension LaunchModel: Equatable { }


//MARK: - getPreddyFormattedDate
extension LaunchModel {
    var getPrettyFormattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions  = [.withFullDate,
                                    .withTime,
                                    .withDashSeparatorInDate,
                                    .withColonSeparatorInTime]
                  
        
        guard let date = formatter.date(from: date_utc) else {
            return "Date format is unkown!"
        }
        
        let friendlyFormatter = DateFormatter()
        friendlyFormatter.calendar = Calendar(identifier: .gregorian)
        friendlyFormatter.setLocalizedDateFormatFromTemplate("yyyy MMMM dd HH:mm:ss")
        
        return friendlyFormatter.string(from: date)
    }
}


//MARK: - Preview
#if DEBUG
extension LaunchModel {
    static var `preview` : [LaunchModel] {
        
        let links = Links(smallPatch: "https://images2.imgbox.com/94/f2/NN6Ph45r_o.png",
                          largePatch: "https://images2.imgbox.com/5b/02/QcxHUb5V_o.png",
                          wikipedia: "https://en.wikipedia.org/wiki/DemoSat")
        return [
            LaunchModel(id: "1235",
                        name: "FalconSat",
                        flight_number: 1,
                        upcoming: false,
                        success: true,
                        details: "Successful first stage burn and transition to second stage, maximum altitude 289 km, Premature engine shutdown at T+7 min 30 s, Failed to reach orbit, Failed to recover first stage",
                        date_utc: "2006-03-24T22:30:00.000Z",
                        date_local: "2006-03-25T10:30:00+12:00",
                        links: links),
            LaunchModel(id: "1236",
                        name: "FalconSat",
                        flight_number: 1,
                        upcoming: false,
                        date_utc: "2006-03-24T22:30:00.000Z",
                        date_local: "2006-03-25T10:30:00+12:00",
                        links: nil),
            LaunchModel(id: "1237",
                        name: "FalconSat",
                        flight_number: 1,
                        upcoming: false,
                        date_utc: "2006-03-24T22:30:00.000Z",
                        date_local: "2006-03-25T10:30:00+12:00",
                        links: .init(smallPatch: "-", largePatch: "-", wikipedia: "-"))
        ]
    }
}
#endif
