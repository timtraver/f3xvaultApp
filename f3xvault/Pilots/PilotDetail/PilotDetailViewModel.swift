//
//  PilotViewModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/6/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// pilot View Model
class PilotDetailViewModel: ObservableObject {
    var pilot_id: Int = 0
    
    @Published var pilotInfo = PilotDetailResponse()
    @Published var networkIndicator = true
    
    init(pilot_id: Int?){
        self.pilot_id = pilot_id ?? 0
        if self.pilot_id != 0 {
            fetchPilot()
        }
        
    }
    
    private func fetchPilot() {
        let call = vaultAPI()
        self.networkIndicator = true
        // Make the API call to check the user entered
        call.getPilotInfo(pilot_id: pilot_id ) { results in
            switch results {
            case .success(var results):
                var rowC = true
                for (index, _) in (results.pilot.pilot_events?.enumerated())! {
                    rowC.toggle()
                    results.pilot.pilot_events![index].rowColor = rowC
                }
                self.pilotInfo = results
                self.networkIndicator = false
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
