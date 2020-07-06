//
//  PilotModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/6/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// Pilot Structures for searchPilots
// The Pilot response object
struct PilotSearchList: Codable{
    var response_code: Int?
    var error_string: String?
    var total_records: Int?
    var pilots: [PilotInfo]?
}
struct PilotInfo: Codable, Identifiable{
    let id = UUID()
    var pilot_id: Int
    var pilot_first_name: String?
    var pilot_last_name: String?
    var country_code: String?
    var rowColor: Bool?
    init(){
        self.pilot_id = 0
        self.pilot_first_name = ""
        self.pilot_last_name = ""
        self.country_code = ""
        self.rowColor = false
    }
}

// Pilot Structures for getPilotInfo
// The Pilot response object
struct PilotDetailResponse: Codable{
    var response_code: Int? = 0
    var error_string: String? = ""
    var pilot = PilotDetail()
}
//struct PilotInfo: Codable{
struct PilotDetail: Codable{
    var pilot_id: Int? = 0
    var pilot_first_name: String? = ""
    var pilot_last_name: String? = ""
    var pilot_ama: String? = ""
    var pilot_fai: String? = ""
    var pilot_fai_license: String? = ""
    var pilot_city: String? = ""
    var state_code: String? = ""
    var country_code: String? = ""
    var pilot_planes: [PilotPlanes]? = []
    var pilot_locations: [PilotLocations]? = []
    var pilot_events: [PilotEvents]? = []
    
}
struct PilotPlanes: Codable, Identifiable {
    let id = UUID()
    var plane_id: Int? = 0
    var plane_name: String? = ""
    var pilot_plane_color: String? = ""
    var pilot_plane_serial: String? = ""
    var pilot_plane_auw: Double? = 0.0
    var pilot_plane_auw_units: String? = ""
}
struct PilotLocations: Codable, Identifiable {
    let id = UUID()
    var location_id: Int? = 0
    var location_name: String? = ""
    var location_city: String? = ""
    var state_code: String? = ""
    var country_code: String? = ""
    var location_coordinates: String? = ""
}
struct PilotEvents: Codable, Identifiable {
    let id = UUID()
    var event_id: Int? = 0
    var event_name: String? = ""
    var location_id: Int? = 0
    var location_name: String? = ""
    var location_city: String? = ""
    var state_code: String? = ""
    var country_code: String? = ""
    var event_start_date: String? = ""
    var event_pilot_position: Int? = 0
    var event_pilot_total_score: String? = ""
    var event_pilot_total_percentage: Double? = 0.0
    var rowColor: Bool? = false
}
