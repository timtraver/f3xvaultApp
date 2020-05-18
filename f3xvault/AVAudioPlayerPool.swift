//
//  AVAudioPlayerPool.swift
//  f3xvault
//
//  Created by Timothy Traver on 5/17/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation
import AVFoundation

private var players : [AVAudioPlayer] = []

class AVAudioPlayerPool: NSObject {

    // Given the URL of a sound file, either create or reuse an audio player
    class func playerWithURL(url : URL) -> AVAudioPlayer? {

        // Try to find a player that can be reused and is not playing
        let availablePlayers = players.filter { (player) -> Bool in
            return player.isPlaying == false && player.url == url
        }

        // If we found one, return it
        if let playerToUse = availablePlayers.first {
            print("Reusing player for \(url.lastPathComponent)")
            return playerToUse
        }

        // Didn't find one? Create a new one
        let newPlayer = try! AVAudioPlayer( contentsOf: url )
        print("Creating new player for url \(url.lastPathComponent)")
        players.append(newPlayer)
        return newPlayer
    }

}

func getPlayer( fileName: String, fileExt: String ) -> AVAudioPlayer? {
    // Wrapper Function to get an audio player from the pool of players by just sending the filename and type
    guard let path = Bundle.main.path(forResource: fileName, ofType: fileExt) else { return nil }
    let url = URL(fileURLWithPath: path)
    return AVAudioPlayerPool.playerWithURL(url: url)
}

