//
//  EventAudioView.swift
//  f3xvault
//
//  Created by Timothy Traver on 5/12/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation

struct EventDetailAudioView: View {
    var eventViewModel: EventDetailViewModel
    @EnvironmentObject var settings: VaultSettings
    
    // Set up a bunch of state variables for the playing and such
    @State var player: AVAudioPlayer!
    @State var playing: Bool = false
    @State var width: CGFloat = 0
    @State var currentFile: String = ""
    @State var finished: Bool = false
    @State var del = AVdelegate()
    @State var currentClock: String = "0:00"

    let horns = getHorns()

    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Audio PlayList")
                            .font(.title)
                            .fontWeight(.semibold)
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToEventDetailView(event_id: self.eventViewModel.event_id , viewSettings: self.settings)
                                    return
                                }) {
                                    Image(systemName: "chevron.left")
                                        .padding(.trailing, 5)
                                    Text("Back")
                                        .foregroundColor(.blue)
                                }
                            }
                        }.frame(height: 20)
                            .padding(.trailing, 5)
                        
                        Spacer()
                    }
                    .padding(.leading, 5)
                    Spacer()
                }
                // Main VStack Content Frame
                VStack(spacing: 1){
                    // Start Main Content Here
                    // Either Using the scroll view or the vstack for control
                    // // // // // // // // // // // // // // // // //
                    //Main Content of view
                    // Event Basic Info Section
                    Group{
                        HStack {
                            Text("Event Name")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.event_name) ")
                            Spacer()
                        }.padding(1.0)
                        HStack {
                            Text("Event Type")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.event_type_name) ")
                                .font(.system(size: 12))
                            Spacer()
                            
                            Button(action: {
                                // Go to audio preferences
                                navigateToEventView(viewName: "EventDetailAudioPrefsView", eventViewModel: self.eventViewModel, viewSettings: self.settings)
                                return
                            }) {
                                Text("Audio Prefs")
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding(1.0)
                    }
                    // Actual Audio player buttons and bar
                    Group{
                        Spacer()
                            .frame(height: 4)
                        ZStack(alignment: .leading){
                            Capsule()
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 20)
                            Capsule()
                                .fill(Color.red.opacity(0.8)).frame(width: self.width, height: 20)
                        }
                        .frame(height: 20)
                        Spacer()
                            .frame(height: 4)
                        HStack{
                            Spacer()
                            Text("\(self.currentClock)")
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .frame(height: 35)
                        .padding(0)
                        Spacer()
                            .frame(height: 4)
                        HStack(spacing: geometry.size.width / 5 - 30){
                            Button(action: {

                            }) {
                                Image(systemName: "backward.fill")
                                    .font(.title)
                            }
                            Button(action: {
//                                self.player.currentTime -= 15
//                                self.updateTime(width: geometry.size.width )
                            }) {
                                Image(systemName: "gobackward.15")
                                    .font(.title)
                            }
                            Button(action: {
                                if self.playing == true {
                                    self.player.stop()
                                    self.playing = false
                                }
                                self.player = getPlayer( fileName: "airhorn1", fileExt: "wav" )
                                if self.player != nil {
                                    self.player.delegate = self.del
                                    self.player.prepareToPlay()
                                    self.player.play()
                                    self.playing = true
                                }
                                
                            }) {
                                Image(systemName: self.playing && !self.finished ? "pause.fill" : "play.fill")
                                    .font(.title)
                            }
                            Button(action: {
//                                self.player.currentTime += 15
//                                self.updateTime(width: geometry.size.width )
                            }) {
                                Image(systemName: "goforward.15")
                                    .font(.title)
                            }
                            Button(action: {
                                //Action
                                UIApplication.shared.isIdleTimerDisabled = true
                                let synth = SpeechSynthesizer()
                                synth.voice = self.settings.audioVoice
                                
                                synth.speak( "Round 1", 0, 0.2 )
                                synth.speak( "F 3 k, Task f - 10 Minute Window - Best Three Flights Maximum 3 minutes, maximum 6 launches", 0, 0.2 )

                                synth.speak( "Group A", 0, 0.2 )
                                synth.speak( "Pilot List, ", 0, 0.2 )
                                for pilot in self.eventViewModel.eventInfo.event.pilots {
                                    let fullname = pilot.pilot_first_name + " " + pilot.pilot_last_name + ","
                                    print(fullname)
                                    synth.speak(fullname)
                                }

//                                synth.speak( "10 Minute Window", 0, 0.2 )
//                                synth.speak( "Best Three Flights Maximum 3 minutes, maximum 6 launches", 0, 0.2 )
                                synth.speak( "\(self.settings.audioPrepTime) minute preparation window Starts in 5, 4, 3, 2, 1", 0, 0.2 )
                                synth.speak( "1 minute No Fly window", 0, 0.2 )


                                return
                            }) {
                                Image(systemName: "forward.fill")
                                    .font(.title)
                            }
                        }
                        .frame(height: 40)
                        .padding(0)
                    }
                    .onAppear{
//                        let url = Bundle.main.path(forResource: "airhorn2", ofType: "wav")
//                        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
//                        self.player.delegate = self.del
//                        self.player.prepareToPlay()
                        
//                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (_) in
//                            if self.player.isPlaying {
//                                self.updateTime(width: geometry.size.width )
//                                self.width = geometry.size.width * CGFloat( self.player.currentTime / self.player.duration )
//                                print(self.player.currentTime)
//                                let currentClockTime = Int( self.player.duration - self.player.currentTime ) + 1
//                                let min = Int( currentClockTime / 60 )
//                                let sec = Int( currentClockTime % 60 )
//                                if sec < 10 {
//                                    self.currentClock = "\(min):0\(sec)"
//                                }else{
//                                    self.currentClock = "\(min):\(sec)"
//                                }
//                            }
//                        }
//                        NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
//                            self.finished = true
//                            self.currentClock = "0:00"
//                        }
                    }
                    
                    Spacer()
                        .frame(height: 4)
                    
                    HStack{
                        HStack {
                            Text("Audio Playlist Queue")
                                .padding(.leading, 5.0)
                                .frame( height: 24.0, alignment: .leading )
                            Spacer()
                        }.padding(.top, 2.0)
                            .background(Color(.systemBlue))
                            .foregroundColor(.white)
                    }
                    HStack(alignment: .top){
                        Text("Num")
                            .frame(width: 30)
                        Text("Queue Description")
                        Spacer()
                    }
                    .font(.system(size: 12))
                    .background(Color(.systemBlue).opacity(0.2))

                    Group{
                        ScrollView{
                            // Task List
                            VStack{
                                Spacer()
                                    .frame(height: 0.01)
                                ForEach( self.eventViewModel.eventInfo.event.tasks ){ task in
                                    Group{
                                        HStack(alignment: .top){
                                            Text("\(task.round_number)")
                                                .frame(width: 30)
                                                .foregroundColor(Color(.black))
                                            Text("\(task.flight_type_name)")
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        .frame(width: geometry.size.width)
                                        .background(Color(.systemBlue).opacity(task.rowColor ?? false ? 0.2 : 0 ))
                                        .foregroundColor(Color(.systemBlue))
                                    }
                                }
                                Spacer()
                                    .frame(height: 20)
                            }
                        }
                        .font(.system(size: 16))
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.71 )
                    
                    Spacer()
                    // End of Main Content Here
                    // Don't touch anything below here unless necessary
                    // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                }
                Spacer()
            }
            ZStack{
                Spacer()
                VStack{
                    if self.eventViewModel.networkIndicator {
                        ActivityIndicator(style: .large)
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height * 0.78 )
                
                Spacer()
                // Inclusion of Tab View
                EventTabView(eventViewModel: self.eventViewModel, width: geometry.size.width, height: geometry.size.height)
            }.zIndex(1)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    func updateTime(width: CGFloat ){
//        self.width = width * CGFloat( self.player.currentTime / self.player.duration )
//        print(self.player.currentTime)
//        let offsetTime = 394.833 - 34.8
//        let currentClockTime = Int( offsetTime - self.player.currentTime ) + 1
//        let min = Int( currentClockTime / 60 )
//        let sec = Int( currentClockTime % 60 )
//        if sec < 0 {
//            if abs(sec) < 10 {
//                self.currentClock = "-\(abs(min)):0\(abs(sec))"
//            }else{
//                self.currentClock = "-\(abs(min)):\(abs(sec))"
//            }
//        }else{
//            if sec < 10 {
//                self.currentClock = "\(min):0\(sec)"
//            }else{
//                self.currentClock = "\(min):\(sec)"
//            }
//        }
    }
}

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}

class SpeechSynthesizer: NSObject {
    private let synthesizer = AVSpeechSynthesizer()
    var voice: String = "en"
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ item: String, _ pauseBefore: Double = 0.0, _ pauseAfter: Double = 0.0 ){
        let speechUtterance = AVSpeechUtterance(string: item)
        speechUtterance.voice = AVSpeechSynthesisVoice( language: self.voice )
        speechUtterance.rate = 0.5
        speechUtterance.preUtteranceDelay = pauseBefore
        speechUtterance.postUtteranceDelay = pauseAfter
        synthesizer.speak(speechUtterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("--- didStart")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("--- didFinish")
    }
}




struct EventDetailAudioView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailAudioView(eventViewModel: EventDetailViewModel(event_id: 0))
    }
}
