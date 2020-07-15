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
    @ObservedObject var eventViewModel: EventDetailViewModel
    @EnvironmentObject var settings: VaultSettings
    
    // Set up a bunch of state variables for the queues and statuses
    @State var soundPlayer: AVAudioPlayer!
    @State var soundDelegate = AVdelegate()
    @State var progressBarWidth: CGFloat = 0
    @State var clockText: String = "0:00"
    @State var clockCurrentSeconds: Double = -1
    @State var clockTotalSeconds: Double = 0.0
    @State var clockOldSeconds: Int = 0
    @State var clockTimerRunning: Bool = false
    @State var clockTimer = Timer.publish (every: 0.05, on: .current, in: .common).autoconnect()
    @State var queueTimerRunning: Bool = false
    @State var queueTimer = Timer.publish (every: 0.2, on: .current, in: .common).autoconnect()
    @State var currentQueueEntry: Int = 0
    @State var goToNextQueueEntry: Bool = false
    @State private var scrollOffset: CGPoint = .zero
    
    let synth = SpeechSynthesizer()
    let horns = getHorns()
    let currentVoice = getCurrentVoice()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Audio PlayList")
                            .font(.title)
                            .fontWeight(.semibold)
                            .fixedSize()
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
                        }
                        .frame(height: 20)
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
                                .frame(width: geometry.size.width, height: 20)
                            Capsule()
                                .fill(Color.red).frame(width: self.progressBarWidth, height: 20, alignment: .center)
                        }
                        .frame(height: 20)
                        Spacer()
                            .frame(height: 4)
                        HStack{
                            Spacer()
                            Text("\(self.clockText)")
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                                .onReceive(self.clockTimer){ _ in
                                    if self.clockTimerRunning && self.clockCurrentSeconds > 0 {
                                        self.clockCurrentSeconds -= 0.05
                                        self.updateClockText(screenWidth: geometry.size.width)
                                    }
                                    if self.clockCurrentSeconds <= 0 {
                                        self.clockCurrentSeconds = 0
                                        self.clockText = "0:00"
                                        self.clockTimer.upstream.connect().cancel()
                                        if self.queueTimerRunning {
                                            if self.eventViewModel.playListQueue[self.currentQueueEntry].hasEndHorn {
                                                // Fire off an end horn
                                                self.playHorn(length: self.eventViewModel.playListQueue[self.currentQueueEntry].endHornLength)
                                            }
                                            self.currentQueueEntry += 1
                                            self.goToNextQueueEntry = true
                                        }
                                    }
                            }
                            Spacer()
                        }
                        .frame(height: 35)
                        .padding(0)
                        Spacer()
                            .frame(height: 4)
                        HStack(spacing: geometry.size.width / 5 - 30){
                            
                            Button(action: {
                                // Lets say all of the flight tasks just to hear them
                                // Call to make the queue go back one
                                return
                            }) {
                                Image(systemName: "backward.fill")
                                    .font(.title)
                                    .onTapGesture{}
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        self.queueBackward()
                                }
                            }
                            
                            Button(action: {
                                if self.clockTotalSeconds != 0 {
                                    self.clockCurrentSeconds += 15
                                    if self.clockCurrentSeconds >= self.clockTotalSeconds {
                                        self.clockCurrentSeconds = self.clockTotalSeconds
                                    }
                                    self.updateClockText(screenWidth: geometry.size.width)
                                }
                                return
                            }) {
                                Image(systemName: "gobackward.15")
                                    .font(.title)
                            }
                            .disabled(self.clockTotalSeconds == 0)
                            
                            Button(action: {
                                // Play and pause button action
                                self.togglePlayPause()
                                return
                            }) {
                                Image(systemName: (self.queueTimerRunning || self.clockTimerRunning) ? "pause.fill" : "play.fill")
                                    .font(.title)
                            }
                            
                            Button(action: {
                                if self.clockTotalSeconds != 0 {
                                    self.clockCurrentSeconds -= 15
                                    if self.clockCurrentSeconds <= 0 {
                                        self.clockCurrentSeconds = 0
                                    }
                                    self.updateClockText(screenWidth: geometry.size.width)
                                }
                                return
                            }) {
                                Image(systemName: "goforward.15")
                                    .font(.title)
                            }
                            .disabled(self.clockTotalSeconds == 0)
                            
                            Button(action: {
                                // Call to make the queue go back one
                                return
                            }) {
                                Image(systemName: "forward.fill")
                                    .font(.title)
                                    .onTapGesture{}
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        self.queueForward()
                                }
                            }
                        }
                        .frame(height: 40)
                        .padding(0)
                    }
                    .onReceive(self.queueTimer){ _ in
                        // The queue timer
                        // Stop the queue timer if it is not supposed to be running
                        if self.queueTimerRunning == false {
                            self.queueTimer.upstream.connect().cancel()
                        }
                        if self.goToNextQueueEntry == true {
                            self.goToNextQueueEntry = false
                            self.processQueueEntry(entry: self.currentQueueEntry)
                            self.scrollOffset = CGPoint(x: 0, y: 40 * self.currentQueueEntry)
                        }
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
                            .frame(width: 35)
                        Text("")
                            .frame(width: 35)
                        Text("Queue Description")
                        Spacer()
                    }
                    .font(.system(size: 12))
                    .background(Color(.systemBlue).opacity(0.2))
                    
                    Group{
                        ScrollableView(self.$scrollOffset, animationDuration: 10.0){
                            // Task List
                            VStack(spacing: 0){
                                ForEach( self.eventViewModel.playListQueue ?? [] ){ queue in
                                    HStack(alignment: .center){
                                        Text("\(queue.sequenceID)")
                                            .frame(width: 35)
                                            .foregroundColor(Color(.black))
                                        if self.currentQueueEntry == queue.sequenceID - 1 {
                                            Image(systemName: "play.fill")
                                                .frame(width: 35, height: 15)
                                        }else{
                                            Text(" ")
                                                .frame(width: 35, height: 15)
                                        }
                                        if !queue.textDescription.contains("Round"){
                                            Text("   ")
                                        }
                                        Text("\(queue.textDescription)")
                                            .fontWeight( queue.textDescription.contains("Round") || queue.textDescription.contains("Flight") ? .bold : .regular )
                                            .foregroundColor(Color( queue.textDescription.contains("Round") ? .black : .systemBlue ) )
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width, height: 40)
                                    .background(Color(.systemBlue).opacity(queue.rowColor ? 0.2 : 0 ))
                                    .foregroundColor(Color(.systemBlue))
                                    .onTapGesture{}
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        self.queueToSpecificEntry(entry: queue.sequenceID - 1 )
                                        self.scrollOffset = CGPoint(x: 0, y: 40 * self.currentQueueEntry)
                                    }
                                }
                                Spacer()
                                    .frame(height: 20)
                            }
                        }
                        .font(.system(size: 16))
                        .onAppear{
                            self.scrollOffset = CGPoint(x: 0, y: 0)
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.61 )
                    
                    Spacer()
                    // End of Main Content Here
                    // Don't touch anything below here unless necessary
                    // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                }
                Spacer()
            }
            .onAppear(){
                NotificationCenter.default.addObserver(forName: Notification.Name("speechFinished"), object: nil, queue: .main, using:self.catchSpeechNotification)
                self.loadQueueState( screenWidth: geometry.size.width )
            }
            .onDisappear(){
                // Code to run when the user exits this screen to save the state of the queue
                self.saveQueueState()
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
    func catchSpeechNotification( notification: Notification ) {
        let queueNum = ( notification.userInfo!["queueNum"] as! NSString ).integerValue
        if queueNum == self.currentQueueEntry {
            if self.currentQueueEntry == self.eventViewModel.playListQueue.count - 1 {
                // reached the end of the playList, so lets stop everything
                self.queueTimerRunning = false
                self.clockTimerRunning = false
                self.synth.stopSpeaking()
                self.soundPlayer?.stop()
                self.soundPlayer?.currentTime = 0
                self.queueTimer.upstream.connect().cancel()  // Stop the queue Timer object to not waste cycles
                self.clockTimer.upstream.connect().cancel()  // Stop the clock Timer object to not waste cycles
                self.goToNextQueueEntry = false
            }else{
                self.currentQueueEntry += 1
                self.goToNextQueueEntry = true
            }
        }
        return
    }
    func updateClockText( screenWidth: CGFloat ){
        let currentSeconds = Int( ceil( self.clockCurrentSeconds ) )
        self.clockText = convertSecondsToClockString( seconds: currentSeconds )
        self.progressBarWidth = screenWidth * CGFloat( self.clockCurrentSeconds / self.clockTotalSeconds )
        // Now lets check to see if we need to announce the time remaining
        if self.clockOldSeconds != currentSeconds {  // This is to prevent it from saying duplicates because the clock time is 0.05
            // Set a boolean on whether or not to accounce the time
            var speak: Bool = false
            var speakSpeed: Double = 0.5
            
            if self.eventViewModel.playListQueue[self.currentQueueEntry].timerLastTen && currentSeconds <= 10 { speak = true }
            if self.eventViewModel.playListQueue[self.currentQueueEntry].timerLastThirty && currentSeconds <= 30 { speak = true }
            if self.eventViewModel.playListQueue[self.currentQueueEntry].timerEveryFifteen &&
                currentSeconds % 15 == 0 &&
                !self.eventViewModel.playListQueue[self.currentQueueEntry].timerEveryTenInLastMinute &&
                currentSeconds <= 60 { speak = true }
            if self.eventViewModel.playListQueue[self.currentQueueEntry].timerEveryMinute && currentSeconds % 60 == 0 { speak = true }
            if self.eventViewModel.playListQueue[self.currentQueueEntry].timerEveryTenInLastMinute && currentSeconds % 10 == 0 && currentSeconds <= 60 { speak = true }
            if self.eventViewModel.playListQueue[self.currentQueueEntry].timerEveryThirty && currentSeconds % 30 == 0 { speak = true }
            if currentSeconds == Int(self.clockTotalSeconds) { speak = false }
            if currentSeconds == 0 { speak = false }
            
            if speak == true {
                var speakText: String = ""
                if currentSeconds >= 60 {
                    let min = Int(currentSeconds/60)
                    let sec = Int(currentSeconds % 60)
                    if sec == 0 {
                        speakText = "\(min) minute"
                        if min > 1 {
                            speakText += "s"
                        }
                    }else{
                        speakText = "\(min) \(sec)"
                    }
                }else{
                    speakText = "\(currentSeconds)"
                    if (currentSeconds >= 15 && !self.eventViewModel.playListQueue[self.currentQueueEntry].timerLastThirty) ||
                        ( currentSeconds > 30 && self.eventViewModel.playListQueue[self.currentQueueEntry].timerEveryTenInLastMinute)
                    {
                        speakText += " seconds"
                    }
                }
                if self.eventViewModel.playListQueue[self.currentQueueEntry].spokenTextOnCountdown != "" && currentSeconds >= 15 {
                    speakText += " \(self.eventViewModel.playListQueue[self.currentQueueEntry].spokenTextOnCountdown)"
                }
                // Lets increase the speaking speed if they are counting down the last thirty and need to be from the voice settings
                if self.eventViewModel.playListQueue[self.currentQueueEntry].timerLastThirty {
                    speakSpeed = 0.5
                    if currentSeconds <= 30 && currentSeconds > 20 && self.currentVoice.thirtySpeed { speakSpeed = 0.58 }
                    if currentSeconds <= 20 && currentSeconds > 10 && self.currentVoice.twentySpeed { speakSpeed = 0.6 }
                }
                self.synth.speak("\(speakText)", false, 0, speakSpeed )
            }
        }
        self.clockOldSeconds = currentSeconds
        return
    }
    func togglePlayPause(){
        // Function to start and stop the main queue running
        // Disable the app from sleeping during the timers running
        UIApplication.shared.isIdleTimerDisabled = true
        if self.queueTimerRunning == true {
            // pause the timer and queue and any voice synthesizer or sound
            self.queueTimerRunning = false
            self.clockTimerRunning = false
            self.synth.stopSpeaking()
            self.soundPlayer?.stop()
            self.soundPlayer?.currentTime = 0
            self.queueTimer.upstream.connect().cancel()  // Stop the queue Timer object to not waste cycles
            self.clockTimer.upstream.connect().cancel()  // Stop the clock Timer object to not waste cycles
        }else{
            self.queueTimerRunning = true
            self.queueTimer = Timer.publish(every: 0.2, on: .current, in: .common).autoconnect()
            if self.eventViewModel.playListQueue[self.currentQueueEntry].hasTimer {
                if self.clockCurrentSeconds == self.clockTotalSeconds {
                    self.goToNextQueueEntry = true
                }else{
                    self.clockTimerRunning = true
                    self.clockTimer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
                }
            }else{
                self.goToNextQueueEntry = true
            }
            self.scrollOffset = CGPoint(x: 0, y: 40 * self.currentQueueEntry)
        }
        return
    }
    func queueForward(){
        // Function to move the queue forward
        self.currentQueueEntry += 1
        self.synth.stopSpeaking()
        self.clockTimerRunning = false
        self.clockTimer.upstream.connect().cancel()
        self.clockCurrentSeconds = self.eventViewModel.playListQueue[self.currentQueueEntry].timerSeconds
        self.clockTotalSeconds = self.eventViewModel.playListQueue[self.currentQueueEntry].timerSeconds
        self.clockText = convertSecondsToClockString( seconds: Int( self.clockCurrentSeconds ) )
        self.progressBarWidth = 0
        if self.queueTimerRunning {
            self.goToNextQueueEntry = true
        }
        self.scrollOffset = CGPoint(x: 0, y: 40 * self.currentQueueEntry)
        return
    }
    func queueBackward(){
        // Function to move the queue back
        if self.currentQueueEntry > 0 {
            self.currentQueueEntry -= 1
        }
        self.synth.stopSpeaking()
        self.clockTimerRunning = false
        self.clockTimer.upstream.connect().cancel()
        self.clockCurrentSeconds = self.eventViewModel.playListQueue[self.currentQueueEntry].timerSeconds
        self.clockTotalSeconds = self.eventViewModel.playListQueue[self.currentQueueEntry].timerSeconds
        self.clockText = convertSecondsToClockString( seconds: Int( self.clockCurrentSeconds ) )
        self.progressBarWidth = 0
        if self.queueTimerRunning {
            self.goToNextQueueEntry = true
        }
        self.scrollOffset = CGPoint(x: 0, y: 40 * self.currentQueueEntry)
        return
    }
    func queueToSpecificEntry(entry: Int){
        // Function to go to a specific queue entry
        self.currentQueueEntry = entry
        self.synth.stopSpeaking()
        self.clockTimerRunning = false
        self.clockTimer.upstream.connect().cancel()
        self.clockCurrentSeconds = self.eventViewModel.playListQueue[self.currentQueueEntry].timerSeconds
        self.clockTotalSeconds = self.eventViewModel.playListQueue[self.currentQueueEntry].timerSeconds
        self.clockText = convertSecondsToClockString( seconds: Int( self.clockCurrentSeconds ) )
        self.progressBarWidth = 0
        if self.queueTimerRunning {
            self.goToNextQueueEntry = true
        }
        self.scrollOffset = CGPoint(x: 0, y: 40 * self.currentQueueEntry)
        return
    }
    func processQueueEntry(entry: Int){
        // Function to process a particular queue entry
        // If the entry has a horn at the beginning, then set it off
        
        // Play a beginning horn if needed
        if self.eventViewModel.playListQueue[entry].hasBeginHorn {
            // play horn
            self.playHorn(length: self.eventViewModel.playListQueue[entry].beginHornLength)
        }
        
        // If the entry has a timer, then set the current timer value and restart the timer
        if self.eventViewModel.playListQueue[entry].hasTimer {
            self.clockTotalSeconds = self.eventViewModel.playListQueue[entry].timerSeconds
            self.clockCurrentSeconds = self.eventViewModel.playListQueue[entry].timerSeconds
            self.clockTimerRunning = true
            self.clockTimer.upstream.connect().cancel()
            self.clockTimer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
        }
        
        // If the entry has some speech, then call the speech synthesizer
        if self.eventViewModel.playListQueue[entry].spokenText != "" {
            self.synth.voice = self.settings.audioVoice
            self.synth.speak(self.eventViewModel.playListQueue[entry].spokenText, self.eventViewModel.playListQueue[entry].spokenTextWait ,self.currentQueueEntry, 0.5, self.eventViewModel.playListQueue[entry].spokenPreDelay, self.eventViewModel.playListQueue[entry].spokenPostDelay)
        }
        return
    }
    func saveQueueState(){
        // Function to save the current queue state, so that when we come back to the view, we can resume
        self.settings.queueEventId = self.eventViewModel.event_id
        self.settings.queueState = self.queueTimerRunning
        self.settings.queueNumber = self.currentQueueEntry
        self.settings.queueTimerState = self.clockTimerRunning
        self.settings.queueTimerCurrentSeconds = self.clockCurrentSeconds
        self.settings.queueTimerTotalSeconds = self.clockTotalSeconds
        self.settings.queueTimerStamp = TimeInterval(Int64(Date().timeIntervalSince1970))
        return
    }
    func loadQueueState( screenWidth: CGFloat ){
        // Function to load the queue state back to the saved value
        // but only if we have come back to the same event
        if self.settings.queueEventId != self.eventViewModel.event_id {
            return
        }
        self.currentQueueEntry = self.settings.queueNumber
        // Calculate what the current clock seconds are supposed to be from when we left
        self.clockTotalSeconds = self.settings.queueTimerTotalSeconds
        if self.settings.queueTimerState {
            // If the timer in the queue was running then do the math to set the seconds
            let diff = TimeInterval(Int64(Date().timeIntervalSince1970)) - self.settings.queueTimerStamp
            let elapsed = self.settings.queueTimerCurrentSeconds - diff
            if elapsed < 0 {
                self.clockCurrentSeconds = 0
            }else{
                self.clockCurrentSeconds = elapsed
            }
        }else{
            // Set the seconds to what they were
            self.clockCurrentSeconds = self.settings.queueTimerCurrentSeconds
        }
        // Update the clock display
        if self.clockCurrentSeconds > 0 {
            self.updateClockText( screenWidth: screenWidth )
        }
        if self.settings.queueState {
            // queue is running so lets start that queue
            self.queueTimerRunning = true
            self.queueTimer = Timer.publish(every: 0.2, on: .current, in: .common).autoconnect()
        }
        if self.settings.queueTimerState {
            // queue timer is running, so lets start that
            self.clockTimerRunning = true
            self.clockTimer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()
        }
        self.scrollOffset = CGPoint(x: 0, y: 40 * self.currentQueueEntry)
        return
    }
    func playHorn(length: Int = 2){
        let fileName = self.horns[UserDefaults.standard.integer( forKey: "audioHorn" )].fileName + "_\(length)"
        self.soundPlayer = getAudioPlayer( fileName: fileName, fileExt: self.horns[UserDefaults.standard.integer( forKey: "audioHorn" )].fileType )
        if self.soundPlayer != nil {
            self.soundPlayer.delegate = self.soundDelegate
            self.soundPlayer.prepareToPlay()
            self.soundPlayer.setVolume(self.settings.audioHornVolume, fadeDuration: 0)
            self.soundPlayer.play()
        }
        return
    }
    
}

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Do something here if we need to after sound plays
    }
}

class SpeechSynthesizer: NSObject {
    var synthesizer = AVSpeechSynthesizer()
    var voice: String = UserDefaults.standard.string( forKey: "audioVoice" ) ?? "com.apple.ttsbundle.Samantha-compact"
    var queueNumber: Int = 0
    var sendNotification: Bool = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ item: String, _ sendNotification: Bool, _ queueNumber: Int, _ speakSpeed: Double = 0.5, _ pauseBefore: Double = 0.0, _ pauseAfter: Double = 0.0 ){
        self.queueNumber = queueNumber
        self.sendNotification = sendNotification
        let speechUtterance = AVSpeechUtterance( string: item )
        speechUtterance.voice = AVSpeechSynthesisVoice( identifier: self.voice )
        speechUtterance.rate = Float( speakSpeed )
        speechUtterance.preUtteranceDelay = pauseBefore
        speechUtterance.postUtteranceDelay = pauseAfter
        self.synthesizer.speak( speechUtterance )
        return
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if self.sendNotification {
            NotificationCenter.default.post(name: Notification.Name("speechFinished"), object: nil, userInfo: ["queueNum" : "\(self.queueNumber)"])
        }
    }
}


struct EventDetailAudioView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailAudioView(eventViewModel: EventDetailViewModel(event_id: 0))
    }
}
