//
//  PilotSearchViewModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/18/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// pilot View Model
class PilotSearchViewModel: ObservableObject {
    
    @Published var pilotList = PilotSearchList()
    @Published var networkIndicator = true
    
    init(){
        self.fetchPilots()
    }
    
    private func fetchPilots() {
        let call = vaultAPI()
        self.networkIndicator = true
        // Make the API call to check the user entered
        call.searchPilots() { results in
            switch results {
            case .success(var results):
                var rowC = true
                for (index, _) in (results.pilots?.enumerated())! {
                    rowC.toggle()
                    results.pilots![index].rowColor = rowC
                }
                self.pilotList = results
                self.networkIndicator = false
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
