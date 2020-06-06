//
//  EventModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/10/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// Event Search structs
struct EventSearchList: Codable{
    var response_code: Int?
    var error_string: String?
    var total_records: Int?
    var events: [EventSearchInfo]?
}
struct EventSearchInfo: Codable, Identifiable {
    let id = UUID()
    var event_id: Int? = 0
    var event_name: String? = ""
    var event_start_date: String? = ""
    var location_name: String? = ""
    var country_code: String? = ""
    var event_type_name: String? = ""
    var event_type_code: String? = ""
    var rowColor: Bool? = false
}

// Event Detail structs
struct EventDetailResponse: Codable {
    var response_code: Int
    var error_string: String
    var event: EventDetailInfo
    init(){
        self.response_code = 0
        self.error_string = ""
        self.event = EventDetailInfo()
    }
}
struct EventDetailInfo: Codable {
    var event_id: Int
    var event_name: String
    var location_id: Int
    var location_name: String
    var country_code: String
    var start_date: String
    var end_date: String
    var event_type_code: String
    var event_type_name: String
    var event_calc_accuracy_string: String
    var total_rounds: Int
    var tasks: [EventTask]
    var pilots: [EventPilot]
    var prelim_standings: EventPrelimStandings
    var flyoff_standings: [EventFlyoffStandings]
    init(){
        self.event_id = 0
        self.event_name = ""
        self.location_id = 0
        self.location_name = ""
        self.country_code = ""
        self.start_date = ""
        self.end_date = ""
        self.event_type_code = ""
        self.event_type_name = ""
        self.event_calc_accuracy_string = ""
        self.total_rounds = 0
        self.tasks = []
        self.pilots = []
        self.prelim_standings = EventPrelimStandings()
        self.flyoff_standings = []
    }
}
struct EventTask: Codable, Identifiable {
    let id = UUID()
    var round_number: Int
    var flight_type_code: String
    var flight_type_name: String
    var flight_type_name_short: String
    var flight_type_description: String
    var flight_type_landing: Int
    var flight_type_minutes: Int
    var flight_type_seconds: Int
    var flight_type_laps: Int
    var flight_type_start_height: Int
    var flight_type_start_penalty: Int
    var flight_type_over_penalty: Int
    var flight_type_sub_flights: Int
    var event_task_time_choice: Int
    var rowColor: Bool?
    init(){
        self.round_number = 0
        self.flight_type_code = ""
        self.flight_type_name = ""
        self.flight_type_name_short = ""
        self.flight_type_description = ""
        self.flight_type_landing = 0
        self.flight_type_minutes = 0
        self.flight_type_seconds = 0
        self.flight_type_laps = 0
        self.flight_type_start_height = 0
        self.flight_type_start_penalty = 0
        self.flight_type_over_penalty = 0
        self.flight_type_sub_flights = 0
        self.event_task_time_choice = 0
        self.rowColor = false
    }
}

struct EventPilot: Codable, Identifiable {
    let id = UUID()
    var pilot_id: Int
    var pilot_bib: Int
    var pilot_first_name: String
    var pilot_last_name: String
    var country_code: String
    var pilot_class: String
    var pilot_ama: String
    var pilot_fai: String
    var pilot_fai_license: String
    var pilot_team: String
    var rowColor: Bool?
    init(){
        self.pilot_id = 0
        self.pilot_bib = 0
        self.pilot_first_name = ""
        self.pilot_last_name = ""
        self.country_code = ""
        self.pilot_class = ""
        self.pilot_ama = ""
        self.pilot_fai = ""
        self.pilot_fai_license = ""
        self.pilot_team = ""
        self.rowColor = false
    }
}

struct EventPrelimStandings: Codable, Identifiable {
    let id = UUID()
    var total_rounds: Int
    var total_drops: Int
    var standings: [EventStandings]
    init(){
        self.total_rounds = 0
        self.total_drops = 0
        self.standings = []
    }
}
struct EventStandings: Codable, Identifiable {
    let id = UUID()
    var pilot_position: Int
    var pilot_id: Int
    var pilot_bib: Int
    var pilot_first_name: String
    var pilot_last_name: String
    var country_code: String
    var total_score: Double
    var total_diff: Double
    var total_drop: Double
    var total_penalties: Int
    var total_percent: Double
    var rounds: [EventPilotRounds]
    var rowColor: Bool?
    init(){
        self.pilot_position = 0
        self.pilot_id = 0
        self.pilot_bib = 0
        self.pilot_first_name = ""
        self.pilot_last_name = ""
        self.country_code = ""
        self.total_score = 0.0
        self.total_diff = 0.0
        self.total_drop = 0.0
        self.total_penalties = 0
        self.total_percent = 0.0
        self.rounds = []
        self.rowColor = false
    }
}
struct EventPilotRounds: Codable, Identifiable{
    let id = UUID()
    var round_number: Int
    var round_score: Double
    var round_dropped: Bool?
    var flights: [EventPilotFlight]
    init(){
        self.round_number = 0
        self.round_score = 0.0
        self.round_dropped = false
        self.flights = []
    }
}

struct EventPilotFlight: Codable, Identifiable {
    let id = UUID()
    var flight_type_code: String
    var flight_type_name: String
    var flight_rank: Int
    var flight_order: Int
    var flight_group: String
    var flight_minutes: Int
    var flight_seconds: String
    var flight_laps: Int
    var flight_landing: Int
    var flight_start_height: Int
    var flight_start_penalty: Int
    var flight_score: Double
    var flight_penalty: Int
    var flight_dropped: Int
    var score_status: Int
    var flight_subs: [EventPilotFlightSub]?
    var rowColor: Bool?
    init(){
        self.flight_type_code = ""
        self.flight_type_name = ""
        self.flight_rank = 0
        self.flight_order = 0
        self.flight_group = ""
        self.flight_minutes = 0
        self.flight_seconds = ""
        self.flight_laps = 0
        self.flight_landing = 0
        self.flight_start_height = 0
        self.flight_start_penalty = 0
        self.flight_score = 0.0
        self.flight_penalty = 0
        self.flight_dropped = 0
        self.score_status = 0
        self.flight_subs = []
        self.rowColor = false
    }
}
struct EventPilotFlightSub: Codable, Identifiable {
    let id = UUID()
    var sub_num: Int
    var sub_val: String
    init(){
        self.sub_num = 0
        self.sub_val = ""
    }
}

struct EventFlyoffStandings: Codable, Identifiable {
    let id = UUID()
    var flyoff_number: Int
    var total_rounds: Int
    var total_drops: Int
    var standings: [EventStandings]
    init(){
        self.flyoff_number = 0
        self.total_rounds = 0
        self.total_drops = 0
        self.standings = []
    }
}

struct EventRound: Codable, Identifiable {
    let id = UUID()
    var flight_type_name: String
    var round_number: Int
    var flights: [EventRoundFlight]
    init(){
        self.flight_type_name = ""
        self.round_number = 0
        self.flights = []
    }
}
struct EventRoundFlight: Codable, Identifiable {
    var id: UUID
    var flight_type_code: String
    var flight_type_name: String
    var flight_header: Bool
    var group_header: Bool
    var pilot_id: Int
    var pilot_bib: Int
    var pilot_first_name: String
    var pilot_last_name: String
    var country_code: String
    var rank: Int
    var group: String
    var order: Int
    var minutes: Int
    var seconds: String
    var laps: Int
    var landing: Int
    var start_height: Int
    var start_penalty: Int
    var score: Double
    var penalty: Int
    var dropped: Int
    var score_status: Int
    var rowColor: Bool
    var subs: [EventPilotFlightSub]?
    init(){
        self.id = UUID()
        self.flight_type_code = ""
        self.flight_type_name = ""
        self.flight_header = false
        self.group_header = false
        self.pilot_id = 0
        self.pilot_bib = 0
        self.pilot_first_name = ""
        self.pilot_last_name = ""
        self.country_code = ""
        self.rank = 0
        self.group = ""
        self.order = 0
        self.minutes = 0
        self.seconds = ""
        self.laps = 0
        self.landing = 0
        self.start_height = 0
        self.start_penalty = 0
        self.score = 0.0
        self.penalty = 0
        self.dropped = 0
        self.score_status = 0
        self.rowColor = false
    }
}
