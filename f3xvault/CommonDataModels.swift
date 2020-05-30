//
//  CommonDataModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/12/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import Foundation

// Run view that does not affect a views content
struct Run: View {
    let block: () -> Void
    
    var body: some View {
        DispatchQueue.main.async(execute: block)
        return AnyView(EmptyView())
    }
}

struct Country: Codable, Equatable {
    let name: String
    let code: String
}
struct Horn: Codable, Equatable, Identifiable {
    var id: Int
    var fileName: String
    var fileType: String
    var description: String
}
struct Voice: Codable, Equatable, Identifiable {
    var id = UUID()
    var code: String
    var name: String
    var identifier: String
}


// A class to store the app settings across lots of views
class VaultSettings: ObservableObject {
    // Currently logged in user
    @Published var keep_logged_in: Bool
    @Published var user_id: Int
    @Published var user_name: String
    @Published var user_first_name: String
    @Published var user_last_name: String
    @Published var pilot_id: Int
    @Published var pilot_ama: String
    @Published var pilot_fai: String
    @Published var pilot_fai_license: String
    @Published var pilot_city: String
    @Published var country_code: String
    @Published var state_code: String
    @Published var atEvent: Int
    
    // Storage of which main tab is active
    @Published var currentMainTab: Tab
    @Published var search: SearchParameters
    
    // Audio Preferences
    @Published var audioVoice: String
    @Published var audioLanguage: String
    @Published var audioPrepTime: Int
    @Published var audioAnnouncePilots: Bool
    @Published var audioHorn: Int
    @Published var audioHornVolume: Float
    
    init(){
        self.keep_logged_in = UserDefaults.standard.bool( forKey: "keep_logged_in" )
        self.user_id = UserDefaults.standard.integer( forKey: "user_id" )
        self.user_name = UserDefaults.standard.string( forKey: "user_name" ) ?? ""
        self.user_first_name = UserDefaults.standard.string( forKey: "user_first_name" ) ?? ""
        self.user_last_name = UserDefaults.standard.string( forKey: "user_last_name" ) ?? ""
        self.pilot_id = UserDefaults.standard.integer( forKey: "pilot_id" )
        self.pilot_ama = UserDefaults.standard.string( forKey: "pilot_ama" ) ?? ""
        self.pilot_fai = UserDefaults.standard.string( forKey: "pilot_fai" ) ?? ""
        self.pilot_fai_license = UserDefaults.standard.string( forKey: "pilot_fai_license" ) ?? ""
        self.pilot_city = UserDefaults.standard.string( forKey: "pilot_city" ) ?? ""
        self.country_code = UserDefaults.standard.string( forKey: "country_code" ) ?? ""
        self.state_code = UserDefaults.standard.string( forKey: "state_code" ) ?? ""
        self.atEvent = 0
        
        self.currentMainTab = Tab.home
        self.search = SearchParameters()
        
        self.audioVoice = UserDefaults.standard.string( forKey: "audioVoice" ) ?? "com.apple.ttsbundle.Samantha-compact"
        self.audioLanguage = UserDefaults.standard.string( forKey: "audioLanguage" ) ?? "en"
        if UserDefaults.standard.integer( forKey: "audioPrepTime" ) == 0 {
            self.audioPrepTime = 2
        }else{
            self.audioPrepTime = UserDefaults.standard.integer( forKey: "audioPrepTime" )
        }
        self.audioAnnouncePilots = UserDefaults.standard.bool( forKey: "audioAnnouncePilots" )
        self.audioHorn = UserDefaults.standard.integer( forKey: "audioHorn" )
        self.audioHornVolume = UserDefaults.standard.float( forKey: "audioHornVolume" )
    }
}

class SearchParameters: ObservableObject {
    @Published var string: String?
    @Published var event_type_code: String?
    @Published var use_dates: Bool?
    @Published var date_from: Date
    @Published var date_to: Date
    @Published var per_page: Int?
    @Published var page: Int?
    @Published var country: String?
    init(){
        self.string = ""
        self.event_type_code = ""
        self.use_dates = false
        self.date_from = Date()
        self.date_to = Date()
        self.per_page = 1000
        self.page = 1
        self.country = ""
    }
}

enum Tab: Hashable {
    case home
    case events
    case locations
    case planes
    case pilots
    case event_main
    case event_rounds
    case event_tasks
    case event_stats
}

struct playQueueEntry: Identifiable {
    var id = UUID()
    var sequenceID: Int
    var textDescription: String
    var spokenText: String
    var spokenTextWait: Bool
    var spokenPreDelay: Double
    var spokenPostDelay: Double
    var spokenTextOnCountdown: String
    var hasBeginHorn: Bool
    var beginHornLength: Int
    var hasEndHorn: Bool
    var endHornLength: Int
    var hasTimer: Bool
    var timerSeconds: Double
    var timerStart: String
    var timerCountdownToStart: Bool
    var timerLastTen: Bool
    var timerLastThirty: Bool
    var timerEveryFifteen: Bool
    var timerEveryThirty: Bool
    var timerEveryTenInLastMinute: Bool
    var timerEveryMinute: Bool
    var hornLength: Int
    var rowColor: Bool
    init(){
        self.sequenceID = 0
        self.textDescription = ""
        self.spokenText = ""
        self.spokenTextWait = true
        self.spokenPreDelay = 0.0
        self.spokenPostDelay = 0.0
        self.spokenTextOnCountdown = ""
        self.hasBeginHorn = false
        self.beginHornLength = 2
        self.hasEndHorn = false
        self.endHornLength = 2
        self.hasTimer = false
        self.timerSeconds = 0.0
        self.timerStart = ""
        self.timerCountdownToStart = false
        self.timerLastTen = true
        self.timerLastThirty = false
        self.timerEveryFifteen = false
        self.timerEveryThirty = false
        self.timerEveryTenInLastMinute = false
        self.timerEveryMinute = false
        self.hornLength = 2
        self.rowColor = false
    }
    
}

class FlightDescriptions{
    // class to hold the description of all of the flight types for use when speaking
    var flights: [String: [String:String]] = [:]
    
    init(){
        setFlights();
    }
    
    func setFlights(){
        // F3K flight types
        self.flights["f3k_a"] = [
            "name" : "F3K Task A - Last 1 x 5:00",
            "description" : "F3k Task A... Last flight... Maximum five minutes... Seven minute working window.",
            "window" : "420",
        ]
        self.flights["f3k_a2"] = [
            "name" : "F3K Task A - Last 1 x 5:00",
            "description" : "F3k Task A... Last Flight... Maximum five minutes... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_b"] = [
            "name" : "F3K Task B - Last 2 x 4:00",
            "description" : "F3k Task B... Last two flights... Maximum four minutes... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_b2"] = [
            "name" : "F3K Task b - Last 2 x 3:00",
            "description" : "F3k Task B... Last two flights... Maximum three minutes. Seven minute working window.",
            "window" : "420",
        ]
        self.flights["f3k_c"] = [
            "name" : "F3K Task C - All Up 3 x 3:00",
            "description" : "F3k Task C... All up last down... Single launch... Maximum three minutes. Three three minute working windows. Must launch before three second start signal ends.",
            "window" : "183",
        ]
        self.flights["f3k_c2"] = [
            "name" : "F3K Task C - All Up 4 x 3:00",
            "description" : "F3k Task C... All up last down... Single launch... Maximum three minutes. Four three minute working windows. Must launch before three second start signal ends.",
            "window" : "183",
        ]
        self.flights["f3k_c3"] = [
            "name" : "F3K Task C - All Up 5 x 3:00",
            "description" : "F3k Task C... All up last down... Single launch... Maximum three minutes. Five three minute working windows. Must launch before three second start signal ends.",
            "window" : "183",
        ]
        self.flights["f3k_d"] = [
            "name" : "F3K Task D - Ladder",
            "description" : "F3k Task D... Ladder... Increasing time by fifteen seconds. Flights of 30 seconds, 45 seconds, 1 minute, 1 minute 15 seconds, 1 minute 30 seconds, 1 minute 45 seconds, and 2 minutes... Ten minute working window. Must achieve or exceed flight time before proceeding to the next target flight.",
            "window" : "600",
        ]
        self.flights["f3k_d2"] = [
            "name" : "F3K Task D (2020) - 2 x 5:00",
            "description" : "F3k Task D... Two flights only... Maximum five minutes. Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_e"] = [
            "name" : "F3K Task E - Poker",
            "description" : "F3k Task E... Poker... Pilot nominated times. Five max target times... Ten minute working window... Must achieve or exceed flight time before proceeding to the next target flight.",
            "window" : "600",
        ]
        self.flights["f3k_e2"] = [
            "name" : "F3K Task E - Poker (2020) 10",
            "description" : "F3k Task E... Poker... Pilot nominated times. Three max target times... Ten minute working window... Must achieve or exceed flight time before proceeding to the next target flight.",
            "window" : "600",
        ]
        self.flights["f3k_e3"] = [
            "name" : "F3K Task E - Poker (2020) 15",
            "description" : "F3k Task E... Poker... Pilot nominated times. Three max target times. Fifteen minute working window... Must achieve or exceed flight time before proceeding to the next target flight.",
            "window" : "900",
        ]
        self.flights["f3k_f"] = [
            "name" : "F3K Task F - Best 3 x 3:00",
            "description" : "F3k Task F... Best three flights... Maximum three minutes... Maximum six launches... Ten Minute Working window.",
            "window" : "600",
        ]
        self.flights["f3k_g"] = [
            "name" : "F3K Task G - Best 5 x 2:00",
            "description" : "F3k Task G... Best five flights... Maximum two minutes... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_h"] = [
            "name" : "F3K Task H - 1, 2, 3, 4",
            "description" : "F3k Task H... One minute, two minute, three minute and four minute maximum flights in any order... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_i"] = [
            "name" : "F3K Task I - 3 x 3:20",
            "description" : "F3k Task I... Three longest flights... Maximum three minutes twenty seconds... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_j"] = [
            "name" : "F3K Task J - Last 3 x 3:00",
            "description" : "F3k Task J... Last three flights... Maximum three minutes... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_k"] = [
            "name" : "F3K Task K - Big Ladder",
            "description" : "F3k Task K... Big Ladder... Five target flights increasing time by thirty seconds... Thirty seconds, one minute, one minute thirty seconds, two minutes, two minutes thirty seconds, and three minute flights in order... All time counts... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_l"] = [
            "name" : "F3K Task L - Single Flight",
            "description" : "F3k Task L... Single flight... Single launch... Max time nine minutes fifty nine seconds... Ten minute working window.",
            "window" : "600",
        ]
        self.flights["f3k_m"] = [
            "name" : "F3K Task M - Huge Ladder 3, 5, 7",
            "description" : "F3k Task M... Huge ladder... Three flights only... Three minute, five minute, and seven minute flights in order... All time achieved counts... Fifteen minute working window.",
            "window" : "900",
        ]
        
        // F3J flight types
        self.flights["f3j_duration"] = [
            "name" : "F3J Duration",
            "description" : "F3j Duration with precision landing... Ten minute working window.",
            "window" : "600",
        ]
        
        // F5J flight types
        self.flights["f5j_duration"] = [
            "name" : "F5J Electric Duration",
            "description" : "F5j Electric duration with precision landing... Ten minute working window.",
            "window" : "600",
        ]
        
        // GPS flight types
        self.flights["gps_distance"] = [
            "name" : "GPS Triangle Distance",
            "description" : "GPS Triangle distance with landing... Maximum laps around GPS triangle... Thirty minute window.",
            "window" : "1800",
        ]
        self.flights["gps_speed"] = [
            "name" : "GPS Triangle Speed",
            "description" : "GPS Triangle speed... Fastest lap around GPS triangle... Five minute window.",
            "window" : "300",
        ]
        
    }
}
