//
//  PlaneDetailViewModel.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/10/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// plane View Model
class PlaneDetailViewModel: ObservableObject {
    var plane_id: Int = 0
    
    @Published var planeDetail = PlaneDetailResponse()
    
    init(plane_id: Int?){
        self.plane_id = plane_id ?? 0
        if self.plane_id != 0 {
            fetchPlaneInfo()
        }
        
    }
    
    private func fetchPlaneInfo() {
        let call = vaultAPI()
        // Make the API call to check the user entered
        call.getPlaneInfo(plane_id: plane_id ) { results in
            switch results {
            case .success(var results):
                var rowC = true
                for (index, _) in (results.plane?.plane_pilots?.enumerated())! {
                    rowC.toggle()
                    results.plane?.plane_pilots![index].rowColor = rowC
                }
                self.planeDetail = results
                return
            case .failure(let error):
                print(error)
            }
        }
        return
    }
}
