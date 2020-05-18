//
//  AudioFiles.swift
//  f3xvault
//
//  Created by Timothy Traver on 5/14/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// Structure data for each sound file that we will use
struct fileInfo: Identifiable {
    let id = UUID()
    var taskDescription: String
    var fileName: String
    var fileExt: String
    var fileDescription: String
    var windowLength: Double
    var offsetTime: Double
}


class f3xAudio{
    var files: [ String : fileInfo ]
    
    init(){
        self.files = [
            "round1" : fileInfo( taskDescription: "Round 1", fileName: "round1", fileExt: "wav", fileDescription: "Round 1 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round2" : fileInfo( taskDescription: "Round 2", fileName: "round2", fileExt: "wav", fileDescription: "Round 2 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round3" : fileInfo( taskDescription: "Round 3", fileName: "round3", fileExt: "wav", fileDescription: "Round 3 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round4" : fileInfo( taskDescription: "Round 4", fileName: "round4", fileExt: "wav", fileDescription: "Round 4 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round5" : fileInfo( taskDescription: "Round 5", fileName: "round5", fileExt: "wav", fileDescription: "Round 5 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round6" : fileInfo( taskDescription: "Round 6", fileName: "round6", fileExt: "wav", fileDescription: "Round 6 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round7" : fileInfo( taskDescription: "Round 7", fileName: "round7", fileExt: "wav", fileDescription: "Round 7 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round8" : fileInfo( taskDescription: "Round 8", fileName: "round8", fileExt: "wav", fileDescription: "Round 8 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round9" : fileInfo( taskDescription: "Round 9", fileName: "round9", fileExt: "wav", fileDescription: "Round 9 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round10" : fileInfo( taskDescription: "Round 10", fileName: "round10", fileExt: "wav", fileDescription: "Round 10 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round11" : fileInfo( taskDescription: "Round 11", fileName: "round11", fileExt: "wav", fileDescription: "Round 11 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round12" : fileInfo( taskDescription: "Round 12", fileName: "round12", fileExt: "wav", fileDescription: "Round 12 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round13" : fileInfo( taskDescription: "Round 13", fileName: "round13", fileExt: "wav", fileDescription: "Round 13 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round14" : fileInfo( taskDescription: "Round 14", fileName: "round14", fileExt: "wav", fileDescription: "Round 14 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round15" : fileInfo( taskDescription: "Round 15", fileName: "round15", fileExt: "wav", fileDescription: "Round 15 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round16" : fileInfo( taskDescription: "Round 16", fileName: "round16", fileExt: "wav", fileDescription: "Round 16 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round17" : fileInfo( taskDescription: "Round 17", fileName: "round17", fileExt: "wav", fileDescription: "Round 17 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round18" : fileInfo( taskDescription: "Round 18", fileName: "round18", fileExt: "wav", fileDescription: "Round 18 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round19" : fileInfo( taskDescription: "Round 19", fileName: "round19", fileExt: "wav", fileDescription: "Round 19 Announcement", windowLength: 0.0, offsetTime: 0.0 ),
            "round20" : fileInfo( taskDescription: "Round 20", fileName: "round20", fileExt: "wav", fileDescription: "Round 20 Announcement", windowLength: 0.0, offsetTime: 0.0 ),

        ]
    }
}

