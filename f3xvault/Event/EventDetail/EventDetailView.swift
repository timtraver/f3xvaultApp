//
//  EventDetailView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/19/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI

struct EventDetailView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    var event_id: Int = 0
    @ObservedObject var eventViewModel = EventDetailViewModel(event_id: 0)
    init(event_id: Int){
        self.event_id = event_id
        loadEventModel()
    }
    
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
                                    navigateToView(viewName: "EventList", viewSettings: self.settings)
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
                VStack{
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
                            Text("\(self.eventViewModel.eventInfo.event.event_name) ")
                            Spacer()
                        }.padding(1.0)
                        HStack {
                            Text("Location")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text(getFlag(from: self.eventViewModel.eventInfo.event.country_code))
                                .frame(width: 20)
                            Text(" - \(self.eventViewModel.eventInfo.event.country_code) - ")
                                .font(.system(size: 12))
                            Text("\(self.eventViewModel.eventInfo.event.location_name) ")
                                .font(.system(size: 12))
                            Spacer()
                        }.padding(1.0)
                        HStack {
                            Text("Start Date")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.start_date) ")
                            Spacer()
                        }.padding(1.0)
                        HStack {
                            Text("Event Type")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.event_type_name) ")
                                .font(.system(size: 12))
                            Spacer()
                        }.padding(1.0)
                    }
                    Spacer()
                        .frame(height: 0.1)
                    // Event Standings List
                    Group{
                        ScrollView{
                            // Flyoff Standings
                            if self.eventViewModel.eventInfo.event.flyoff_standings.count > 0 {
                                ForEach( self.eventViewModel.eventInfo.event.flyoff_standings ){ flyoff in
                                    VStack{
                                        HStack {
                                            Text("Event Flyoff \(flyoff.flyoff_number) Standings")
                                                .padding(.leading, 5.0)
                                                .frame( height: 24.0, alignment: .leading )
                                            Spacer()
                                            if flyoff.total_rounds > 0 {
                                                Text("( \(flyoff.total_rounds) Rounds)")
                                                    .font(.system(size: 12))
                                            }
                                        }.padding(.top, 2.0)
                                            .background(Color(.systemBlue))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                            .frame(height: 0.01)
                                        
                                        ScrollView(.horizontal){
                                            VStack{
                                                FlyoffPilotHeader(flyoff: flyoff)
                                                FlyoffPilotRows(flyoff: flyoff, eventViewModel: self.eventViewModel)
                                            }
                                        }
                                        .font(.system(size: 16))
                                    }
                                }
                            }
                            
                            // Preliminary Standings
                            HStack {
                                Text("Event Preliminary Standings")
                                    .padding(.leading, 5.0)
                                    .frame( height: 24.0, alignment: .leading )
                                Spacer()
                                if self.eventViewModel.eventInfo.event.total_rounds > 0 {
                                    Text("( \(self.eventViewModel.eventInfo.event.total_rounds) Rounds)")
                                        .font(.system(size: 12))
                                }
                            }.padding(.top, 2.0)
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Spacer()
                                .frame(height: 0.01)
                            ScrollView(.horizontal){
                                VStack{
                                    PrelimPilotHeader(total_rounds: self.eventViewModel.eventInfo.event.total_rounds, eventViewModel: self.eventViewModel)
                                    
                                    PrelimPilotRows(standings: self.eventViewModel.eventInfo.event.prelim_standings.standings , eventViewModel: self.eventViewModel)
                                    Spacer()
                                }
                                .frame(minHeight: geometry.size.height * 0.65 )
                            }
                            .font(.system(size: 16))
                            Spacer()
                        }
                        .font(.system(size: 20))
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.72 )
                    
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
    
    mutating func loadEventModel(){
        eventViewModel = EventDetailViewModel(event_id: self.event_id)
    }
}

struct FlyoffPilotHeader: View {
    var flyoff:EventFlyoffStandings
    
    var body: some View {
        HStack(alignment: .top){
            Text("Pos")
                .frame(width: 24)
            Text("Bib")
                .frame(width: 24)
            Spacer()
                .frame(width: 35)
            HStack{
                Text("Pilot Name")
                Spacer()
            }
            Spacer()
            Text("Total")
                .frame(width: 70, alignment: .trailing)
            Text("Diff")
                .frame(width: 60, alignment: .leading)
            Text("Drop")
                .frame(width: 60, alignment: .trailing)
            Text("Pen")
                .frame(width: 60, alignment: .trailing)
            if self.flyoff.total_rounds > 0 {
                ForEach( 0..<self.flyoff.total_rounds){ num in
                    Group{
                        Text("Round \(num + 1)")
                            .font(.system(size: 10))
                            .frame(width: 70, height: 12)
                            .padding(0)
                    }
                }
            }
        }
        .font(.system(size: 14))
        .background(Color(.systemBlue).opacity(0.2))
    }
}

struct FlyoffPilotRows: View{
    var flyoff: EventFlyoffStandings
    var eventViewModel: EventDetailViewModel
    
    @EnvironmentObject var settings: VaultSettings
    
    var body: some View {
        ForEach( self.flyoff.standings ){ pilot in
            HStack{
                Text("\(pilot.pilot_position)")
                    .frame(width: 24)
                    .foregroundColor(Color(.black))
                Text("\(pilot.pilot_bib)")
                    .frame(width: 24, height: 24)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                Text(getFlag(from: pilot.country_code ))
                    .frame(width: 20, height: 20)
                HStack{
                    Text("\(pilot.pilot_first_name) \(pilot.pilot_last_name)")
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
                HStack{
                    Text("\(pilot.total_score, specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.black))
                        .frame(width: 70, alignment: .trailing)
                    if pilot.total_diff != 0 {
                        Text("\(pilot.total_diff, specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.red))
                            .frame(width: 60, alignment: .leading)
                    }else{
                        Text("")
                            .frame(width: 60)
                    }
                    if pilot.total_drop != 0 {
                        Text("\(pilot.total_drop, specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.red))
                            .frame(width: 60, alignment: .trailing)
                    }else{
                        Text("")
                            .frame(width: 60)
                    }
                    if pilot.total_penalties != 0 {
                        Text("\(pilot.total_penalties)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.red))
                            .frame(width: 60, alignment: .trailing)
                    }else{
                        Text("")
                            .frame(width: 60)
                    }
                }
                ForEach( pilot.rounds ){ round in
                    PilotFlight(round: round, eventViewModel: self.eventViewModel)
                }
            }
            .frame(height: 30)
            .background(Color(.systemBlue).opacity(pilot.rowColor ?? false ? 0.2 : 0 ))
            .foregroundColor(Color(.systemBlue))
            .padding(.bottom, 1)
        }
        
    }
}

struct PrelimPilotHeader: View {
    var total_rounds: Int
    var eventViewModel: EventDetailViewModel
    
    var body: some View {
        HStack(alignment: .top){
            Text("Pos")
                .frame(width: 25)
            Text("Bib")
                .frame(width: 25)
            Spacer()
                .frame(width: 35)
            HStack{
                Text("Pilot Name")
                Spacer()
            }
            Spacer()
            Text("Total")
                .frame(width: 70, alignment: .trailing)
            Text("Diff")
                .frame(width: 60, alignment: .leading)
            Text("Drop")
                .frame(width: 60, alignment: .trailing)
            Text("Pen")
                .frame(width: 60, alignment: .trailing)
            if self.total_rounds > 0 {
                ForEach( 0..<self.total_rounds){ num in
                    Group{
                        Text("Round \(num + 1)")
                            .font(.system(size: 10))
                            .frame(width: 70, height: 12)
                            .padding(0)
                    }
                }
            }
        }
        .font(.system(size: 14))
        .background(Color(.systemBlue).opacity(0.2))
    }
}

struct PrelimPilotRows: View{
    var standings: [EventStandings]
    var eventViewModel: EventDetailViewModel
    
    var body: some View {
        ForEach( self.standings ){ pilot in
            HStack{
                Text("\(pilot.pilot_position)")
                    .frame(width: 25)
                    .foregroundColor(Color(.black))
                Text("\(pilot.pilot_bib)")
                    .frame(width: 25, height: 24)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                Text(getFlag(from: pilot.country_code ))
                    .frame(width: 20, height: 20)
                HStack{
                    Text("\(pilot.pilot_first_name) \(pilot.pilot_last_name)")
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
                HStack{
                    Text("\(pilot.total_score, specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.black))
                        .frame(width: 70, alignment: .trailing)
                    if pilot.total_diff != 0 {
                        Text("\(pilot.total_diff, specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.red))
                            .frame(width: 60, alignment: .leading)
                    }else{
                        Text("")
                            .frame(width: 60)
                    }
                    if pilot.total_drop != 0 {
                        Text("\(pilot.total_drop, specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.red))
                            .frame(width: 60, alignment: .trailing)
                    }else{
                        Text("")
                            .frame(width: 60)
                    }
                    if pilot.total_penalties != 0 {
                        Text("\(pilot.total_penalties)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.red))
                            .frame(width: 60, alignment: .trailing)
                    }else{
                        Text("")
                            .frame(width: 60)
                    }
                }
                ForEach( pilot.rounds ){ round in
                    PilotFlight(round: round, eventViewModel: self.eventViewModel)
                }
            }
            .frame(height: 30)
            .background(Color(.systemBlue).opacity(pilot.rowColor ?? false ? 0.2 : 0 ))
            .foregroundColor(Color(.systemBlue))
            .padding(.bottom, 1)
        }
        
    }
}

struct PilotFlight: View{
    var round: EventPilotRounds
    var eventViewModel: EventDetailViewModel
    @EnvironmentObject var settings: VaultSettings
    var body: some View{
        HStack{
            if isScored() {
                Button(action: {
                    // Send it to the particular round
                    navigateToEventRoundView(round: self.round.round_number ,  eventViewModel: self.eventViewModel, viewSettings: self.settings)
                    return
                }) {
                    HStack{
                        Text("\(round.round_score , specifier: self.eventViewModel.eventInfo.event.event_calc_accuracy_string)")
                            .strikethrough( round.round_dropped ?? false ? true : false, color: .red)
                            .frame(width: 70, height: 30)
                    }
                    .font(.system(size: 12))
                    .padding(0)
                    .foregroundColor( round.round_dropped ?? false ? Color(.red) :Color(.black))
                    .overlay( round.round_score == 1000 ? Rectangle().stroke(Color.green, lineWidth: 2) : Rectangle().stroke(Color.green, lineWidth: 0) )
                }
            }
        }
    }
    func isScored() -> Bool {
        var returnStatus = false
        for flight in self.round.flights {
            if flight.score_status == 1 {
                returnStatus = true
            }
        }
        return returnStatus
    }
}


struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event_id: 0).environmentObject(VaultSettings())
    }
}
