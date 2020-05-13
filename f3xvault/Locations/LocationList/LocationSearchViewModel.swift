//
//  PlaneModelView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// plane View Model
class LocationSearchViewModel: ObservableObject {
    var discipline: String = ""
    
    @Published var locationList = locationSearchList()
    @Published var networkIndicator = true
    
    init(discipline: String?){
        self.discipline = discipline ?? ""
        fetchLocations()
    }
    
    private func fetchLocations() {
        let call = vaultAPI()
        self.networkIndicator = true
        // Make the API call to check the user entered
        call.searchLocations(discipline: discipline) { results in
            switch results {
            case .success(var results):
                var rowC = true
                for (index, _) in (results.locations?.enumerated())! {
                    rowC.toggle()
                    results.locations![index].rowColor = rowC
                }
                self.locationList = results
                self.networkIndicator = false
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
