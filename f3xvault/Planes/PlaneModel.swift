//
//  PlaneModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// Plane Structures for searchPlanes
// The Plane response object
struct planeSearchList: Codable{
    var response_code: Int?
    var error_string: String?
    var total_records: Int?
    var planes: [PlaneInfo]?
}
struct PlaneInfo: Codable, Identifiable {
    let id = UUID()
    var plane_id: Int?
    var plane_name: String?
    var plane_wing_area: Double?
    var plane_tail_area: Double?
    var plane_wing_area_units: String?
    var plane_manufacturer: String?
    var country_code: String?
    var plane_max_g: Double?
    var plane_max_oz: Double?
    var plane_wingspan: Double?
    var plane_wingspan_units: String?
    var plane_length: Double?
    var plane_length_units: String?
    var plane_year: Int?
    var plane_website: String?
    var rowColor: Bool?
}

struct PlaneDetailResponse: Codable {
    var response_code: Int?
    var error_string: String?
    var plane: PlaneDetail?
}

struct PlaneDetail: Codable, Identifiable {
    let id = UUID()
    var plane_id: Int?
    var plane_name: String?
    var plane_wing_area: Double?
    var plane_tail_area: Double?
    var plane_wing_area_units: String?
    var plane_manufacturer: String?
    var country_code: String?
    var plane_max_g: Double?
    var plane_max_oz: Double?
    var plane_wingspan: Double?
    var plane_wingspan_units: String?
    var plane_length: Double?
    var plane_length_units: String?
    var plane_year: Int?
    var plane_website: String?
    var disciplines: [PlaneDiscipline]? = []
    var plane_media: [PlaneMedia]? = []
    var plane_pilots: [PlanePilot]? = []
}

struct PlaneDiscipline: Codable, Identifiable {
    let id = UUID()
    var discipline_description: String? = ""
}
struct PlaneMedia: Codable, Identifiable {
    let id = UUID()
    var plane_media_id: Int? = 0
    var plane_media_type: String? = ""
    var plane_media_url: String? = ""
    var user_id: Int? = 0
    var pilot_first_name: String? = ""
    var pilot_last_name: String? = ""
    var pilot_country: String? = ""
}
struct PlanePilot: Codable, Identifiable {
    let id = UUID()
    var pilot_id: Int? = 0
    var pilot_first_name: String? = ""
    var pilot_last_name: String? = ""
    var country_code: String? = ""
    var rowColor: Bool? = false
}
