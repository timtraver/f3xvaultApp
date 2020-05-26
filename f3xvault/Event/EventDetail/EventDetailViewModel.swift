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
    @Published var playListQueue: [playQueueEntry]!
    
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
    
    public func createPlaylist(){
        // This is a method to create the playlist from the eventDetailViewModel data
        var playList: [playQueueEntry]! = []
        
        if self.eventInfo.event.event_type_code == "f3k" {
            // Build f3k audio playlist from the rounds and flights
            let rounds = self.getRounds()
            let groups = self.getGroups()
            var sequence:Int = 1
            var tempEntry: playQueueEntry!
            var rowColor: Bool = false
            
            for round in rounds {
                let taskInfo: [String:String] = getTaskDescription(round: round.round_number)
                let prepTime: Int = UserDefaults.standard.integer( forKey: "audioPrepTime" )
                let announcePilots: Bool = UserDefaults.standard.bool( forKey: "audioAnnouncePilots" )
                
                for group in groups {
                    // Add the Round header entry
                    tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    tempEntry.textDescription = "Round \(round.round_number) - Group \(group)"
                    tempEntry.spokenText = "Round \(round.round_number)... Group \(group)"
                    tempEntry.spokenTextWait = true
                    rowColor.toggle()
                    tempEntry.rowColor = rowColor
                    playList.append(tempEntry)
                    sequence += 1
                    //Add task description entry
                    tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    tempEntry.textDescription = taskInfo["name"] ?? ""
                    tempEntry.spokenText = taskInfo["description"] ?? ""
                    // Add the prep time notice if they don't want to announce pilots
                    if announcePilots == false {
                        tempEntry.spokenText += "...Preparation Time of \(prepTime) minutes starts in...5...4...3...2...1..."
                    }
                    tempEntry.spokenTextWait = true
                    rowColor.toggle()
                    tempEntry.rowColor = rowColor
                    playList.append(tempEntry)
                    sequence += 1
                    //Add pilot list entry if wanted
                    if announcePilots == true {
                        tempEntry = playQueueEntry()
                        tempEntry.sequenceID = sequence
                        tempEntry.textDescription = "Group \(group) Pilot List"
                        let pilotList = getPilotList(round: round.round_number, group: group)
                        tempEntry.spokenText = "Group \(group)... pilot list: "
                        for pilot in pilotList {
                            tempEntry.spokenText += "\(pilot),"
                        }
                        tempEntry.spokenText += "...Preparation Time of \(prepTime) minutes starts in...5...4...3...2...1..."
                        tempEntry.spokenTextWait = true
                        rowColor.toggle()
                        tempEntry.rowColor = rowColor
                        playList.append(tempEntry)
                        sequence += 1
                    }
                    
                    // Preperation Time entry
                    tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    tempEntry.textDescription = "\(convertSecondsToClockString(seconds: prepTime * 60)) Preparation Time"
                    tempEntry.spokenText = "\(prepTime) minutes remaining in prep time."
                    tempEntry.spokenTextWait = false
                    tempEntry.spokenTextOnCountdown = "remaining in prep time."
                    tempEntry.hasTimer = true
                    tempEntry.timerSeconds = Double( prepTime * 60 )
                    tempEntry.timerEveryFifteen = true
                    tempEntry.timerEveryThirty = true
                    rowColor.toggle()
                    tempEntry.rowColor = rowColor
                    playList.append(tempEntry)
                    sequence += 1
                    
                    // Add the 1 minute no fly time
                    tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    tempEntry.textDescription = "1:00 No Fly Time"
                    tempEntry.spokenText = "1 Minute no fly time before launch window"
                    tempEntry.spokenTextWait = false
                    tempEntry.spokenTextOnCountdown = "remaining before launch window"
                    tempEntry.hasTimer = true
                    tempEntry.timerSeconds = 60
                    tempEntry.timerEveryFifteen = true
                    tempEntry.timerLastTen = true
                    tempEntry.hasEndHorn = true
                    rowColor.toggle()
                    tempEntry.rowColor = rowColor
                    playList.append(tempEntry)
                    sequence += 1
                    
                    // Add the window time entry
                    tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    let windowTime = Int( taskInfo["window"]! )
                    tempEntry.textDescription = "\(convertSecondsToClockString(seconds: windowTime!)) Flight Window"
                    tempEntry.spokenText = ""
                    tempEntry.hasBeginHorn = false
                    tempEntry.hasTimer = true
                    tempEntry.timerSeconds = Double(windowTime ?? 0)
                    tempEntry.timerEveryMinute = true
                    tempEntry.timerEveryThirty = true
                    tempEntry.timerLastTen = true
                    tempEntry.timerLastThirty = true
                    tempEntry.timerEveryTenInLastMinute = true
                    tempEntry.hasEndHorn = true
                    rowColor.toggle()
                    tempEntry.rowColor = rowColor
                    playList.append(tempEntry)
                    sequence += 1
                    
                    // Add the landing window entry
                    tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    tempEntry.textDescription = "30 Second Landing window"
                    tempEntry.spokenText = "30 Second landing window"
                    tempEntry.spokenPreDelay = 2.0
                    tempEntry.spokenTextWait = false
                    tempEntry.spokenTextOnCountdown = "in landing window"
                    tempEntry.hasTimer = true
                    tempEntry.timerSeconds = 30.0
                    tempEntry.timerEveryTenInLastMinute = true
                    tempEntry.timerLastTen = true
                    tempEntry.hasEndHorn = true
                    rowColor.toggle()
                    tempEntry.rowColor = rowColor
                    playList.append(tempEntry)
                    sequence += 1
                    
                    // 10 second round separation
                    tempEntry = playQueueEntry()
                    tempEntry.sequenceID = sequence
                    tempEntry.textDescription = "10 Second Spacer"
                    tempEntry.spokenText = ""
                    tempEntry.hasTimer = true
                    tempEntry.timerLastTen = false
                    tempEntry.timerSeconds = 10.0
                    rowColor.toggle()
                    tempEntry.rowColor = rowColor
                    playList.append(tempEntry)
                    sequence += 1
                    
                }
            }
        }
        self.playListQueue = playList
        return
    }
    
    private func getRounds() -> [EventRound]{
        // Function to create the arrat of rounds so it is easier to create the queue list
        var rounds: [EventRound]! = []
        let roundNumbers = self.getNumRounds()
        if roundNumbers.count > 0 {
            for round_num in roundNumbers {
                var tempRound = EventRound()
                tempRound.round_number = round_num
                for pilot in self.eventInfo.event.prelim_standings.standings {
                    for round in pilot.rounds {
                        if round.round_number == round_num {
                            for flight in round.flights {
                                var tempFlight = EventRoundFlight()
                                tempRound.flight_type_name = flight.flight_type_code
                                tempFlight.flight_type_code = flight.flight_type_code
                                tempFlight.group = flight.flight_group
                                tempFlight.pilot_first_name = pilot.pilot_first_name
                                tempFlight.pilot_last_name = pilot.pilot_last_name
                                tempRound.flights.append(tempFlight)
                            }
                        }
                    }
                }
                rounds.append(tempRound)
            }
        }
        return rounds ?? []
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
        groups.sort()
        return groups
    }
    private func getNumRounds() -> [Int] {
        // Function to get how many rounds there the standings
        var rounds: [Int] = []
        // Step through the standings and determine the rounds
        for pilot in self.eventInfo.event.prelim_standings.standings {
            for round in pilot.rounds {
                if !rounds.contains(round.round_number) {
                    rounds.append(round.round_number)
                }
            }
        }
        rounds.sort()
        return rounds
    }
    private func getPilotList(round:Int, group:String) -> [String] {
        var pilots: [String] = []
        for pilot in self.eventInfo.event.prelim_standings.standings {
            for roundDetail in pilot.rounds {
                if roundDetail.round_number == round {
                    for flight in roundDetail.flights {
                        if flight.flight_group == group {
                            pilots.append( "\(pilot.pilot_first_name) \(pilot.pilot_last_name)")
                        }
                    }
                }
            }
        }
        return pilots
    }
    
    
}
