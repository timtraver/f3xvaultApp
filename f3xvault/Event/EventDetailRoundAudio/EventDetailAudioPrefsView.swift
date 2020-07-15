//
//  EventDetailAudioPrefs.swift
//  f3xvault
//
//  Created by Timothy Traver on 5/16/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation

struct EventDetailAudioPrefsView: View {
    var eventViewModel: EventDetailViewModel
    @EnvironmentObject var settings: VaultSettings
    
    @State var selectedPrepTime: Int = UserDefaults.standard.integer( forKey: "audioPrepTime" )
    @State var selectedBetweenTime: Double = UserDefaults.standard.double( forKey: "audioBetweenTime" )
    @State var selectedNoFlyTime: Bool = UserDefaults.standard.bool( forKey: "audioNoFlyTime" )
    @State var selectedLanguage: String = UserDefaults.standard.string( forKey: "audioLanguage" ) ?? "en"
    @State var selectedVoice: String = UserDefaults.standard.string( forKey: "audioVoice" ) ?? "com.apple.ttsbundle.Samantha-compact"
    @State var selectedAnnouncePilots: Bool = UserDefaults.standard.bool( forKey: "audioAnnouncePilots" )
    @State var selectedHorn: Int = UserDefaults.standard.integer( forKey: "audioHorn" )
    @State var selectedHornVolume: Float = UserDefaults.standard.float( forKey: "audioHornVolume" )

    @State private var player: AVAudioPlayer!
    @State private var del = AVdelegate()
    
    let voices = getVoices()
    let languages = getLanguages()
    let prepTimes = getPrepTimes()
    let inBetweenTimes = getBetweenTimes()
    let horns = getHorns()
    let hornVolumes = getVolumes()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack{
                        Text("Audio Prefs")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 5)
                    Spacer()
                }
                
                // Main VStack Content Frame
                VStack{
                    VStack(spacing: 1){
                        NavigationView{
                            // Start Main Content Here
                            // Either Using the scroll view or the vstack for control
                            // // // // // // // // // // // // // // // // //
                            
                            Form{
                                
                                Section(header: Text("Audio Playlist Preferences")){
                                    Toggle(isOn: self.$selectedAnnouncePilots) {
                                        Text("Announce Pilots in Groups")
                                    }
                                    Picker(selection: self.$selectedLanguage, label: Text("Language")) {
                                        ForEach( self.languages, id: \.key) { lang in
                                            Text(lang.value)
                                        }
                                    }
                                    Picker(selection: self.$selectedVoice, label: Text("Voice")) {
                                        ForEach( self.voices, id: \.identifier ) { voice in
                                            Text("\(voice.code) \(voice.name)")
                                        }
                                    }
                                }
                                Section(header: Text("Sounds")){
                                    Picker(selection: self.$selectedHorn.onChange(self.previewHorn), label: Text("Horn Type")) {
                                        ForEach( self.horns) { horn in
                                            Text(horn.description)
                                        }
                                    }
                                    Picker(selection: self.$selectedHornVolume, label: Text("Horn Relative Volume")) {
                                        ForEach( self.hornVolumes, id: \.key ) { volume in
                                            Text(volume.value)
                                        }
                                    }
                                }
                                Section(header: Text("Timing")){
                                    Picker(selection: self.$selectedPrepTime, label: Text("Prep Time Length")) {
                                        ForEach( self.prepTimes, id: \.key) { time in
                                            Text(time.value)
                                        }
                                    }
                                    Picker(selection: self.$selectedBetweenTime, label: Text("Time Between Rounds")) {
                                        ForEach( self.inBetweenTimes, id: \.key) { between in
                                            Text(between.value)
                                        }
                                    }
                                }
                                Section(header: Text("For F3K Only")){
                                    Toggle(isOn: self.$selectedNoFlyTime) {
                                        Text("Use 1 Minute No Fly Time")
                                    }
                                }

                            }
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                        }
                        
                        Button(action: {
                            // Action Here
                            // Set the environment variables to what they selected
                            self.settings.audioLanguage = "en"
                            self.settings.audioVoice = "com.apple.ttsbundle.Samantha-compact"
                            self.settings.audioPrepTime = 2
                            self.settings.audioBetweenTime = 1
                            self.settings.audioNoFlyTime = true
                            self.settings.audioAnnouncePilots = true
                            self.settings.audioHorn = 0
                            self.settings.audioHornVolume = 1.0
                            saveSettings(settings: self.settings)
                            // Now go back to the search screen
                            navigateToEventView( viewName: "EventDetailAudioView", eventViewModel: self.eventViewModel , viewSettings: self.settings)
                            return
                        }) {
                            HStack{
                                Spacer()
                                    .frame(width: 20.0)
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 30))
                                    .frame(width: 30)
                                Spacer()
                                    .frame(width: 20.0)
                                Text("Reset To Defaults")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.white))
                                    .frame(width: 200)
                                Spacer()
                            }
                            .frame(width: 300.0, height: 50.0)
                            .background(Color(.systemOrange))
                            .cornerRadius(10)
                        }
                        .foregroundColor(Color(.white))
                        
                        Spacer()
                        
                        Button(action: {
                            self.settings.audioLanguage = self.selectedLanguage
                            self.settings.audioVoice = self.selectedVoice
                            self.settings.audioAnnouncePilots = self.selectedAnnouncePilots
                            self.settings.audioPrepTime = self.selectedPrepTime
                            self.settings.audioBetweenTime = self.selectedBetweenTime
                            self.settings.audioNoFlyTime = self.selectedNoFlyTime
                            self.settings.audioHorn = self.selectedHorn
                            self.settings.audioHornVolume = self.selectedHornVolume
                            saveSettings(settings: self.settings)
                            // Re-create the audio playlist in case some of the prefs have been changed
                            self.eventViewModel.createPlaylist()
                            // Now go back to the search screen
                            navigateToEventView( viewName: "EventDetailAudioView", eventViewModel: self.eventViewModel , viewSettings: self.settings)
                            return
                        }) {
                            HStack{
                                Spacer()
                                    .frame(width: 20.0)
                                Image(systemName: "line.horizontal.3.decrease.circle")
                                    .font(.system(size: 30))
                                    .frame(width: 30)
                                Spacer()
                                    .frame(width: 20.0)
                                Text("Save Audio Prefs")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.white))
                                    .frame(width: 200)
                                Spacer()
                            }
                            .frame(width: 300.0, height: 50.0)
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                        }
                        .foregroundColor(Color(.white))
                        Spacer()
                        
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.83 )
                    .edgesIgnoringSafeArea(.bottom)
                    Spacer()
                }
                Spacer()
                
            }.frame(width: geometry.size.width, height: geometry.size.height * 0.9 )
            Spacer()
            ZStack{
                // Inclusion of Tab View
                Spacer()
                EventTabView( eventViewModel: self.eventViewModel, width: geometry.size.width, height: geometry.size.height )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func previewHorn(_ hornNum: Int){
        self.player = getAudioPlayer(fileName: self.horns[hornNum].fileName + "_2", fileExt: self.horns[hornNum].fileType)
        if self.player != nil {
            self.player.delegate = self.del
            self.player.prepareToPlay()
            self.player.setVolume(self.selectedHornVolume, fadeDuration: 0)
            self.player.play()
        }
        return
    }
    
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

struct EventDetailAudioPrefsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailAudioPrefsView(eventViewModel: EventDetailViewModel(event_id: 0))
    }
}
