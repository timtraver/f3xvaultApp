//
//  EventDetailRoundsView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/25/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI

struct EventDetailRoundsView: View {

    @State var round: Int
    @ObservedObject var eventViewModel: EventDetailViewModel

    @EnvironmentObject var settings: VaultSettings
    
    var roundType: String{ getRoundType() }

    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Event Detail")
                            .font(.title)
                            .fontWeight(.semibold)
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToEventDetailView(event_id: self.eventViewModel.event_id , viewSettings: self.settings)
                                    return
                                }) {
                                    Image(systemName: "chevron.left")
                                        .padding(.trailing, 5)
                                    Text("Back")
                                        .foregroundColor(.blue)
                                }
                            }
                        }.frame(height: 20)
                            .padding(.trailing, 5)
                        
                        Spacer()
                    }
                    .padding(.leading, 5)
                    Spacer()
                }
                // Main VStack Content Frame
                VStack(spacing: 0.0){
                    // Start Main Content Here
                    // Either Using the scroll view or the vstack for control
                    // // // // // // // // // // // // // // // // //
                    //Main Content of view
                    // Event Basic Info Section
                    Group{
                        HStack {
                            Text("Event Name")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.event_name ) ")
                            Spacer()
                        }.padding(1.0)
                        
                        HStack {
                            Text("Location")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text(getFlag(from: self.eventViewModel.eventInfo.event.country_code ))
                                .frame(width: 20)
                            Text(" - \(self.eventViewModel.eventInfo.event.country_code ) - ")
                                .font(.system(size: 12))
                            Text("\(self.eventViewModel.eventInfo.event.location_name ) ")
                                .font(.system(size: 12))
                            Spacer()
                        }.padding(1.0)
                        
                        HStack {
                            Text("Start Date")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.start_date ) ")
                            Spacer()
                        }.padding(1.0)
                        
                        HStack {
                            Text("Event Type")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.event_type_name ) ")
                                .font(.system(size: 12))
                            Spacer()
                        }.padding(1.0)
                        
                        HStack{
                            Spacer()
                            Button(action: {
                                if self.round > 1 {
                                    self.round = self.round - 1
                                }else{
                                    self.round = 1
                                }
                                return
                            }) {
                                Image(systemName: "chevron.left")
                                    .opacity( self.round == 1 ? 0.2 : 1)
                            }
                            Spacer()
                            Spacer()
                            Text("Round \(self.round)")
                                .fontWeight(.semibold)
                            Spacer()
                            Spacer()
                            Button(action: {
                                if self.round < self.eventViewModel.eventInfo.event.tasks.count {
                                    self.round = self.round + 1
                                }else{
                                    self.round = self.eventViewModel.eventInfo.event.tasks.count
                                }
                                return
                            }) {
                                Image(systemName: "chevron.right")
                                    .opacity( self.round == self.eventViewModel.eventInfo.event.tasks.count ? 0.2 : 1)
                            }
                            Spacer()
                        }
                        .font(.system(size: 30))
                        .frame(height:50)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .padding(.vertical, 1.0)

                    }
                    
                    Spacer()
                        .frame(height: 0.1)
                    
                    // Event Standings List
                    Group{
                        
                        ScrollView{
                            
                            // Round List
                            // list of pilots and their round scores
                            
                            Spacer()
                                .frame(height: 0.01)
                            ScrollView(.horizontal){
                                VStack(alignment: .leading, spacing: 0.0){
                                    ForEach(self.calculateRoundArray(round: self.round)){ flight in
                                        if flight.flight_header == true {
                                            HStack{
                                                Spacer()
                                                HStack {
                                                    Text("\(flight.flight_type_name)")
                                                        .padding(.leading, 5.0)
                                                        .frame( height: 24.0, alignment: .leading )
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .background(Color(.systemBlue))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 1.0)
                                        }
                                        if flight.group_header == true {
                                            HStack(spacing: 2.0){
                                                Group{
                                                HStack {
                                                    Text("Group \(flight.group)")
                                                        .fontWeight(.bold)
                                                        .padding(.leading, 5.0)
                                                    Spacer()
                                                }
                                                .frame(width: 280, height: 30)
                                                
                                                if self.flightHasTime(flight_type_code: flight.flight_type_code) {
                                                    HStack{
                                                        Spacer()
                                                        Text("Time")
                                                    }
                                                    .frame(width: 70, alignment: .trailing)
                                                }
                                                HStack{
                                                    Text("Score")
                                                }
                                                .frame(width: 55, alignment: .trailing)
                                                }
                                                Group{
                                                if self.flightHasLaps(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)
                                                    
                                                    HStack{
                                                        Text("Laps")
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                                
                                                if self.flightHasLanding(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)

                                                    HStack{
                                                        Text("Land")
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                                if self.flightHasStartHeight(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)

                                                    HStack{
                                                        Text("Start Height")
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                                if self.flightHasStartPenalty(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)

                                                    HStack{
                                                        Text("Start Pen")
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                                }
                                                Spacer()
                                                    .frame(width: 10)

                                                PilotSubNums(subs: flight.subs ?? [])
                                                
                                            }
                                            .background(Color(.systemBlue).opacity(0.2))
                                            .foregroundColor(.black)
                                            .padding(.vertical, 0.0)
                                            
                                        }
                                        HStack(spacing: 2.0){
                                            Group{
                                                Text("\(flight.rank)")
                                                    .frame(width: 20)
                                                    .foregroundColor(Color(.black))
                                                Text("\(flight.pilot_bib)")
                                                    .frame(width: 24, height: 24)
                                                    .background(Color(.systemBlue))
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 12))
                                                Text(getFlag(from: flight.country_code ))
                                                    .frame(width: 20, height: 20)
                                                HStack{
                                                    Text("\(flight.pilot_first_name) \(flight.pilot_last_name)")
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                                .frame(width: 210)
                                            }
                                            Group{
                                                if self.flightHasTime(flight_type_code: flight.flight_type_code) {
                                                    HStack{
                                                        Spacer()
                                                        if flight.minutes == 0 {
                                                            Text("\(flight.seconds)")
                                                                .fontWeight(.bold)
                                                        }else{
                                                            Text("\(flight.minutes) : \(flight.seconds)")
                                                                .fontWeight(.bold)
                                                        }
                                                    }
                                                    .foregroundColor(Color(.black))
                                                    .font(.system(size: 12))
                                                    .frame(width: 70, alignment: .trailing)
                                                }
                                                
                                                HStack{
                                                    Text("\(flight.score, specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                                                        .strikethrough( flight.dropped == 1 ? true : false, color: .red)
                                                        .font(.system(size: 12))
                                                        .foregroundColor( flight.dropped == 1 ? Color(.red) :Color(.black))
                                                }
                                                .frame(width: 55, alignment: .trailing)
                                                
                                                // make a laps column if needed
                                                if self.flightHasLaps(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)

                                                    HStack{
                                                        Text("\(flight.laps)")
                                                            .foregroundColor(Color(.black))
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                                
                                                // make a landing column if needed
                                                if self.flightHasLanding(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)

                                                    HStack{
                                                        Text("\(flight.landing)")
                                                            .foregroundColor(Color(.black))
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                                // make a start height column if needed
                                                if self.flightHasStartHeight(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)

                                                    HStack{
                                                        Text("\(flight.start_height)")
                                                            .foregroundColor(Color(.black))
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                                // make a start penalty column if needed
                                                if self.flightHasStartPenalty(flight_type_code: flight.flight_type_code) {
                                                    Spacer()
                                                        .frame(width: 10)

                                                    HStack{
                                                        Text("\(flight.start_penalty)")
                                                            .foregroundColor(Color(.black))
                                                    }
                                                    .frame(width: 55, alignment: .trailing)
                                                }
                                            }
                                            Spacer()
                                                .frame(width: 10)

                                            PilotSub(subs: flight.subs ?? [])
                                            
                                        }
                                        .frame(height: 30)
                                        .background(Color(.systemGray).opacity(flight.rowColor ? 0.2 : 0 ))
                                        .foregroundColor(Color(.systemBlue))
                                        .padding(.bottom, 1)
                                    }
                                    
                                }
                                .frame(minWidth: geometry.size.width, alignment: .leading)
                                .font(.system(size: 14))
                                Spacer()
                            }
                            
                            
                        }
                        .font(.system(size: 20))
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.64 )
                    
                    Spacer()
                    // End of Main Content Here
                    // Don't touch anything below here unless necessary
                    // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                }
                Spacer()
            }
            ZStack{
                Spacer()
                VStack{
                    if self.eventViewModel.networkIndicator {
                        ActivityIndicator(style: .large)
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height * 0.78 )
                
                Spacer()
                // Inclusion of Tab View
                EventTabView(eventViewModel: self.eventViewModel, width: geometry.size.width, height: geometry.size.height)
            }.zIndex(1)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func calculateRoundArray(round: Int) -> [EventRoundFlight]{
        // Let us step through the eventViewModel and create whatever round we need to show
        var flight1 = [EventRoundFlight]()
        var flight2 = [EventRoundFlight]()
        var flight3 = [EventRoundFlight]()
        var returnList = [EventRoundFlight]()

        var rowColor = false
        var flightNumber = 0
            // Step through the standings
            for pilot in self.eventViewModel.eventInfo.event.prelim_standings.standings {
                // Create the temporary structure for this pilot
                var tempRound = EventRoundFlight()
                tempRound.pilot_id = pilot.pilot_id
                tempRound.pilot_bib = pilot.pilot_bib
                tempRound.pilot_first_name = pilot.pilot_first_name
                tempRound.pilot_last_name = pilot.pilot_last_name
                tempRound.country_code = pilot.country_code
                for round in pilot.rounds {
                    if round.round_number == self.round {
                        flightNumber = 1
                        for flight in round.flights {
                            tempRound.flight_type_code = flight.flight_type_code
                            tempRound.flight_type_name = flight.flight_type_name
                            tempRound.rank = flight.flight_rank
                            tempRound.order = flight.flight_order
                            tempRound.group = flight.flight_group
                            tempRound.minutes = flight.flight_minutes
                            tempRound.seconds = flight.flight_seconds
                            tempRound.laps = flight.flight_laps
                            tempRound.landing = flight.flight_landing
                            tempRound.start_height = flight.flight_start_height
                            tempRound.start_penalty = flight.flight_start_penalty
                            tempRound.score = flight.flight_score
                            tempRound.penalty = flight.flight_penalty
                            tempRound.dropped = flight.flight_dropped
                            tempRound.score_status = flight.score_status
                            tempRound.subs = flight.flight_subs
                            
                            
                            // Now put this temp record into the corrent flight
                            switch flightNumber {
                            case 1:
                                flight1.append(tempRound)
                                break
                            case 2:
                                flight2.append(tempRound)
                                break
                            case 3:
                                flight3.append(tempRound)
                                break
                            default:
                                break
                            }
                            flightNumber += 1
                        }
                    }
                }
            }
        
        // Now lets check the flyoff rounds for flights
            // Step through the standings
        for standings in self.eventViewModel.eventInfo.event.flyoff_standings {
            flightNumber = 0
            for pilot in standings.standings {
                // Create the temporary structure for this pilot
                var tempRound = EventRoundFlight()
                tempRound.pilot_id = pilot.pilot_id
                tempRound.pilot_bib = pilot.pilot_bib
                tempRound.pilot_first_name = pilot.pilot_first_name
                tempRound.pilot_last_name = pilot.pilot_last_name
                tempRound.country_code = pilot.country_code
                for round in pilot.rounds {
                    if round.round_number == self.round {
                        flightNumber = 1
                        for flight in round.flights {
                            tempRound.flight_type_code = flight.flight_type_code
                            tempRound.flight_type_name = flight.flight_type_name
                            tempRound.rank = flight.flight_rank
                            tempRound.order = flight.flight_order
                            tempRound.group = flight.flight_group
                            tempRound.minutes = flight.flight_minutes
                            tempRound.seconds = flight.flight_seconds
                            tempRound.laps = flight.flight_laps
                            tempRound.landing = flight.flight_landing
                            tempRound.start_height = flight.flight_start_height
                            tempRound.start_penalty = flight.flight_start_penalty
                            tempRound.score = flight.flight_score
                            tempRound.penalty = flight.flight_penalty
                            tempRound.dropped = flight.flight_dropped
                            tempRound.score_status = flight.score_status
                            tempRound.subs = flight.flight_subs
                            
                            // Now put this temp record into the corrent flight
                            switch flightNumber {
                            case 1:
                                flight1.append(tempRound)
                                break
                            case 2:
                                flight2.append(tempRound)
                                break
                            case 3:
                                flight3.append(tempRound)
                                break
                            default:
                                break
                            }
                            flightNumber += 1
                        }
                    }
                }
            }
        }
        
        // sort the returned arrays by their group and rank
        flight1.sort { ($0.group, $0.rank, $0.pilot_first_name) < ($1.group, $1.rank, $1.pilot_first_name) }
        flight2.sort { ($0.group, $0.rank, $0.pilot_first_name) < ($1.group, $1.rank, $1.pilot_first_name) }
        flight3.sort { ($0.group, $0.rank, $0.pilot_first_name) < ($1.group, $1.rank, $1.pilot_first_name) }

        // Step through and set the row colors and the flight header tagafter the sort
        var oldGroup: String = "blah"
        var firstEntry: Bool = true
        for pilot in flight1 {
            var tempRound = pilot
            if firstEntry {
                tempRound.flight_header = true
                firstEntry = false
            }
            rowColor.toggle()
            tempRound.rowColor = rowColor
            if tempRound.group != oldGroup {
                tempRound.group_header = true
            }
            oldGroup = tempRound.group
            returnList.append(tempRound)
        }
        oldGroup = "blah"
        firstEntry = true
        for pilot in flight2 {
            var tempRound = pilot
            if firstEntry {
                tempRound.flight_header = true
                firstEntry = false
            }
            rowColor.toggle()
            tempRound.rowColor = rowColor
            if tempRound.group != oldGroup {
                tempRound.group_header = true
            }
            oldGroup = tempRound.group
            returnList.append(tempRound)
        }
        oldGroup = "blah"
        firstEntry = true
        for pilot in flight3 {
            var tempRound = pilot
            if firstEntry {
                tempRound.flight_header = true
                firstEntry = false
            }
            rowColor.toggle()
            tempRound.rowColor = rowColor
            if tempRound.group != oldGroup {
                tempRound.group_header = true
            }
            oldGroup = tempRound.group
            returnList.append(tempRound)
        }
        
        // Reset the index id for the returned list so it keeps its order
        for (index, _) in ( returnList.enumerated()){
            returnList[index].id = UUID()
//            if self.eventViewModel.eventInfo.event.event_type_code != "f3b" {
//                returnList[index].flight_header = false
//            }
        }
        
        return returnList
    }
    func getRoundType() -> String {
        // Function to get the round flight type if there is one
        var returnType:String = ""
        for task in self.eventViewModel.eventInfo.event.tasks {
            if task.round_number == self.round {
                returnType = task.flight_type_name
            }
        }
        if self.eventViewModel.eventInfo.event.event_type_code == "f3b" {
            returnType = "F3B Multi Task Round"
        }
        return returnType
    }
    func flightHasTime(flight_type_code: String) -> Bool {
        // If it is an f3b event, then check the individual flight types
        if flight_type_code == "f3b_duration" {
            return true
        }else if flight_type_code == "f3b_distance" {
            return false
        }else if flight_type_code == "f3b_speed" {
            return true
        }
        // Otherwise, check the task list for whether or not it has time
        for task in self.eventViewModel.eventInfo.event.tasks {
            if task.round_number == self.round && ( task.flight_type_minutes == 1 || task.flight_type_seconds == 1 ) {
                return true
            }
        }
        return false
    }
    func flightHasLaps(flight_type_code: String) -> Bool {
        // If it is an f3b event, then check the individual flight types
        if flight_type_code == "f3b_duration" {
            return false
        }else if flight_type_code == "f3b_distance" {
            return true
        }else if flight_type_code == "f3b_speed" {
            return false
        }

        for task in self.eventViewModel.eventInfo.event.tasks {
            if task.round_number == self.round && task.flight_type_laps == 1 {
                return true
            }
        }
        return false
    }
    func flightHasLanding(flight_type_code: String) -> Bool {
        // If it is an f3b event, then check the individual flight types
        if flight_type_code == "f3b_duration" {
            return true
        }else if flight_type_code == "f3b_distance" {
            return false
        }else if flight_type_code == "f3b_speed" {
            return false
        }
        
        for task in self.eventViewModel.eventInfo.event.tasks {
            if task.round_number == self.round && task.flight_type_landing == 1 {
                return true
            }
        }
        return false
    }
    func flightHasStartPenalty(flight_type_code: String) -> Bool {
        // If it is an f3b event, then check the individual flight types
        if flight_type_code == "f3b_duration" || flight_type_code == "f3b_distance" || flight_type_code == "f3b_speed" {
            return false
        }
        
        for task in self.eventViewModel.eventInfo.event.tasks {
            if task.round_number == self.round && task.flight_type_start_penalty == 1 {
                return true
            }
        }
        return false
    }
    func flightHasStartHeight(flight_type_code: String) -> Bool {
        // If it is an f3b event, then check the individual flight types
        if flight_type_code == "f3b_duration" || flight_type_code == "f3b_distance" || flight_type_code == "f3b_speed" {
            return false
        }
        
        for task in self.eventViewModel.eventInfo.event.tasks {
            if task.round_number == self.round && task.flight_type_start_height == 1 {
                return true
            }
        }
        return false
    }

}
struct PilotSub: View{
    var subs: [EventPilotFlightSub]
    var body: some View{
        ForEach( subs ){ sub in
            HStack{
                Text("\(sub.sub_val)")
            }
            .frame(width: 50)
            .font(.system(size: 12))
            .foregroundColor(Color(.black))
        }
    }
}
struct PilotSubNums: View{
    var subs: [EventPilotFlightSub]
    var body: some View{
        ForEach( subs ){ sub in
            HStack{
                Text("\(sub.sub_num)")
            }
            .frame(width: 50)
            .font(.system(size: 12))
            .foregroundColor(Color(.black))
        }
    }
}


struct EventDetailRoundsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailRoundsView(round: 1, eventViewModel: EventDetailViewModel(event_id: 0))
    }
}
