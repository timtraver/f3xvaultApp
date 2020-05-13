//
//  LocationDetailViewModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/16/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// location detail View Model
class LocationDetailViewModel: ObservableObject {
    var location_id: Int = 0
    
    @Published var locationInfo = LocationDetailResponse()
    
    init(location_id: Int?){
        self.location_id = location_id ?? 0
        if self.location_id != 0 {
            fetchLocation()
        }
        
    }
    
    private func fetchLocation() {
        let call = vaultAPI()
        // Make the API call to check the user entered
        call.getLocationInfo(location_id: location_id ) { results in
            switch results {
            case .success(var results):
                var rowC = true
                for (index, _) in (results.location?.location_events?.enumerated())! {
                    rowC.toggle()
                    results.location?.location_events![index].rowColor = rowC
                }
                self.locationInfo = results
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
