//
//  LocationModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/15/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// Location Structures for searchLocations
// The Location response object
struct locationSearchList: Codable{
    var response_code: Int?
    var error_string: String?
    var total_records: Int?
    var locations: [LocationInfo]?
}
struct LocationInfo: Codable, Identifiable {
    let id = UUID()
    var location_id: Int?
    var location_name: String?
    var location_city: String?
    var state_code: String?
    var country_code: String?
    var location_coordinates: String?
    var location_club: String?
    var location_club_url: String?
    var rowColor: Bool?
}

struct LocationDetailResponse: Codable{
    var response_code: Int?
    var error_string: String?
    var location: LocationDetail?
}

struct LocationDetail: Codable, Identifiable {
    let id = UUID()
    var location_id: Int? = 0
    var location_name: String? = ""
    var location_city: String? = ""
    var state_code: String? = ""
    var country_code: String? = ""
    var location_coordinates: String? = ""
    var location_club: String? = ""
    var location_club_url: String? = ""
    var location_description: String? = ""
    var location_directions: String? = ""
    var disciplines: [LocationDiscipline]? = []
    var location_events: [LocationEvents]? = []
    var location_media: [LocationMedia]? = []
}
struct LocationDiscipline: Codable, Identifiable {
    let id = UUID()
    var discipline_description: String? = ""
}
struct LocationEvents: Codable, Identifiable {
    let id = UUID()
    var event_id: Int? = 0
    var event_name: String? = ""
    var event_start_date: String? = ""
    var event_type_name: String? = ""
    var event_type_code: String? = ""
    var total_pilots: Int? = 0
    var rowColor: Bool? = false
}
struct LocationMedia: Codable, Identifiable {
    let id = UUID()
    var location_media_id: Int? = 0
    var location_media_type: String? = ""
    var location_media_url: String? = ""
    var user_id: Int? = 0
    var pilot_first_name: String? = ""
    var pilot_last_name: String? = ""
    var pilot_country: String? = ""
}
