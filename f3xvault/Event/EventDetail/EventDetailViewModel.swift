//
//  EventDetailViewModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/19/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// pilot View Model
class EventDetailViewModel: ObservableObject {
    var event_id: Int = 0
    
    @Published var eventInfo = EventDetailResponse()
    @Published var networkIndicator = true
    @Published var playListQueue: [playQueueEntry]?

    init(event_id: Int?){
        self.event_id = event_id ?? 0
        if self.event_id != 0 {
            fetchEvent()
        }
    }
    
    private func fetchEvent() {
        let call = vaultAPI()
        self.networkIndicator = true
        // Make the API call to check the user entered
        call.getEventInfo(event_id: event_id ) { results in
            switch results {
            case .success(var results):
                var rowC = true

                // Set the row color for the task list
                for (index, _) in (results.event.tasks.enumerated()) {
                    rowC.toggle()
                    results.event.tasks[index].rowColor = rowC
                }
                // Set the row color for the pilot list
                for (index, _) in (results.event.pilots.enumerated()) {
                    rowC.toggle()
                    results.event.pilots[index].rowColor = rowC
                }
                // Set the row color for the flyoff pilots list
                if results.event.prelim_standings.standings.count > 0 {
                    for (index, _) in (results.event.prelim_standings.standings.enumerated()) {
                        rowC.toggle()
                        results.event.prelim_standings.standings[index].rowColor = rowC
                        
                        // Lets determine if the round has been dropped from its flights
                        for (index2, _) in ( results.event.prelim_standings.standings[index].rounds.enumerated()){
                            var dropped = true
                            for flight in results.event.prelim_standings.standings[index].rounds[index2].flights {
                                if flight.flight_dropped == 0 {
                                    dropped = false
                                }
                            }
                            results.event.prelim_standings.standings[index].rounds[index2].round_dropped = dropped
                        }
                    }
                }
                // Set the row color for the flyoff pilots list
                if results.event.flyoff_standings.count > 0 {
                    for (index, _) in (results.event.flyoff_standings.enumerated()) {
                        for (index2, _) in ((results.event.flyoff_standings[index].standings.enumerated())) {
                            rowC.toggle()
                            results.event.flyoff_standings[index].standings[index2].rowColor = rowC
                            
                            // Lets determine if the round has been dropped from its flights
                            for (index3, _) in ( results.event.flyoff_standings[index].standings[index2].rounds.enumerated()){
                                var dropped = true
                                for flight in results.event.flyoff_standings[index].standings[index2].rounds[index3].flights {
                                    if flight.flight_dropped == 0 {
                                        dropped = false
                                    }
                                }
                                results.event.flyoff_standings[index].standings[index2].rounds[index3].round_dropped = dropped
                            }
                        }
                    }
                }
                
                self.eventInfo = results
                self.networkIndicator = false
                self.createPlaylist()
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
    
    private func createPlaylist(){
        // This is a method to create the playlist from the eventDetailViewModel data
        print("Got into createPlayList")
        if self.eventInfo.event.event_type_code == "f3k" {
            print("Got into f3k playlist")

            // Build f3k audio playlist from the rounds and flights
            var groups = self.getGroups()
            var sequence:Int = 1
            
            
            
            
            for pilot in self.eventInfo.event.prelim_standings.standings {
                for round in pilot.rounds {
                    var tempFlightInfo = self.getTaskDescription(round: round.round_number)
                    var tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    tempEntry.textDescription = "Round \(round.round_number)"
                    tempEntry.spokenText = "Round \(round.round_number)"
                    
                    
                    
                                
                    
                    
                    
                    
                    
                    
                    

                }
            }

            
            
            
            
            
            
            
        }
        
        
    }
    private func addQueueEntry(entry: playQueueEntry){
        // Function to add a ueue entry to the onject array
        
        return
    }
    private func getTaskDescription(round: Int) -> [String:String]{
        // Function to get the round task description for the particular round
        let flightTypes = FlightDescriptions()
        var returnArray: [String:String] = [:]
        for task in self.eventInfo.event.tasks {
            if task.round_number == round {
                let code = task.flight_type_code
                returnArray = flightTypes.flights[code] ?? [:]
            }
        }
        return returnArray
    }
    private func getGroups() -> [String] {
        // Function to determine how many groups there are in each round
        var groups: [String] = []
        // Step through the rounds and determine the groups
        for pilot in self.eventInfo.event.prelim_standings.standings {
            for round in pilot.rounds {
                for flight in round.flights {
                    if !groups.contains(flight.flight_group) {
                        groups.append(flight.flight_group)
                    }
                }
            }
        }
        return groups
    }
    private func getPilotList(round:Int, group:String) -> [String] {
        var pilots: [String] = []
        
        
        return pilots
    }
    
    
}
