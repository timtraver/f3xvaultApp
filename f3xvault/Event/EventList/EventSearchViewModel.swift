//
//  EventSearchViewModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/10/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// plane View Model
class EventSearchViewModel: ObservableObject {
    
    @Published var eventList = EventSearchList()
    @Published var networkIndicator = true
    
    init(){
        self.fetchEvents()
    }
    
    private func fetchEvents() {
        let call = vaultAPI()
        self.networkIndicator = true
        // Make the API call to check the user entered
        call.searchEvents() { results in
            switch results {
            case .success(var results):
                var rowC = true
                for (index, _) in (results.events?.enumerated())! {
                    rowC.toggle()
                    results.events![index].rowColor = rowC
                }
                self.eventList = results
                self.networkIndicator = false
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
