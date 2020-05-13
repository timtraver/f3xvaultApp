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
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
