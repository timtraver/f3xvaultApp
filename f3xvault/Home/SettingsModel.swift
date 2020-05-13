//
//  SettingsModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation

// A class to store the app settings across lots of views
class VaultSettings: ObservableObject {
    // Currently logged in user
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
    
    init(){
        self.user_id = 0
        self.user_name = ""
        self.user_first_name = ""
        self.user_last_name = ""
        self.pilot_id = 0
        self.pilot_ama = ""
        self.pilot_fai = ""
        self.pilot_fai_license = ""
        self.pilot_city = ""
        self.country_code = ""
        self.state_code = ""
        self.atEvent = 0
        
        self.currentMainTab = Tab.home
        self.search = SearchParameters()
        
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

