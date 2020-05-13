//
//  HomeViewModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/19/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// home View Model
class HomeViewModel: ObservableObject {
    var pilot_id: Int = 0
    
    @Published var pilotInfo = PilotDetailResponse()
    @Published var atEvent = 0
    @Published var lastEvent = 0
    
    init(pilot_id: Int?){
        self.pilot_id = pilot_id ?? 0
        if self.pilot_id != 0 {
            fetchPilot()
        }
    }
    
    private func fetchPilot() {
        let call = vaultAPI()
        // Make the API call to check the user entered
        call.getPilotInfo(pilot_id: pilot_id ) { results in
            switch results {
            case .success(let results):
                self.pilotInfo = results
                // Step through the events and set the flag if they are at one
                for event in results.pilot.pilot_events ?? [] {
                    if isDatePast(dateString: event.event_start_date) && self.lastEvent == 0 {
                        self.lastEvent = event.event_id ?? 0
                    }
                    if isDateToday(dateString: event.event_start_date) {
                        // stuff
                        self.atEvent = event.event_id ?? 0
                        break
                    }
                }
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
