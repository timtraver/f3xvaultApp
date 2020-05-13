//
//  PlaneModelView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// plane View Model
class PlaneSearchViewModel: ObservableObject {
    
    @Published var planeList = planeSearchList()
    @Published var networkIndicator = true
    
    init(){
        self.fetchPlanes()
    }
    
    private func fetchPlanes() {
        let call = vaultAPI()
        self.networkIndicator = true
        // Make the API call to check the user entered
        call.searchPlanes() { results in
            switch results {
            case .success(var results):
                var rowC = true
                for (index, _) in (results.planes?.enumerated())! {
                    rowC.toggle()
                    results.planes![index].rowColor = rowC
                }
                self.planeList = results
                self.networkIndicator = false
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
