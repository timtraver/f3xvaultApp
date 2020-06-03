//
//  CommonFunctions.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/5/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

func saveSettings(settings: VaultSettings){
    // Simple Function to save the UserDefault settings
    UserDefaults.standard.set( settings.keep_logged_in, forKey: "keep_logged_in")
    UserDefaults.standard.set( settings.user_id, forKey: "user_id")
    UserDefaults.standard.set( settings.user_name, forKey: "user_name")
    UserDefaults.standard.set( settings.user_first_name, forKey: "user_first_name")
    UserDefaults.standard.set( settings.user_last_name, forKey: "user_last_name")
    UserDefaults.standard.set( settings.pilot_id, forKey: "pilot_id")
    UserDefaults.standard.set( settings.pilot_ama, forKey: "pilot_ama")
    UserDefaults.standard.set( settings.pilot_fai, forKey: "pilot_fai")
    UserDefaults.standard.set( settings.pilot_fai_license, forKey: "pilot_fai_license")
    UserDefaults.standard.set( settings.pilot_city, forKey: "pilot_city")
    UserDefaults.standard.set( settings.country_code, forKey: "country_code")
    UserDefaults.standard.set( settings.state_code, forKey: "state_code")
    // Audio prefernce settings
    UserDefaults.standard.set( settings.audioVoice, forKey: "audioVoice")
    UserDefaults.standard.set( settings.audioLanguage, forKey: "audioLanguage")
    UserDefaults.standard.set( settings.audioPrepTime, forKey: "audioPrepTime")
    UserDefaults.standard.set( settings.audioNoFlyTime, forKey: "audioNoFlyTime")
    UserDefaults.standard.set( settings.audioAnnouncePilots, forKey: "audioAnnouncePilots")
    UserDefaults.standard.set( settings.audioHorn, forKey: "audioHorn")
    UserDefaults.standard.set( settings.audioHornVolume, forKey: "audioHornVolume")
    
}
func getFlag(from countryCode: String) -> String {
    return countryCode
        .unicodeScalars
        .map({ 127397 + $0.value })
        .compactMap(UnicodeScalar.init)
        .map(String.init)
        .joined()
}

// Date Functions
func showDate(dateString: String?) -> String{
    if dateString == "" || dateString == nil {
        return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString!)
    dateFormatter.dateFormat = "yy/MM"
    return dateFormatter.string(from: date!)
}
func isDateToday(dateString: String?) -> Bool{
    if dateString == "" || dateString == nil {
        return false
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString!)
    let now = Date()
    if now > date! && now <= date!.addingTimeInterval(86400) {
        return true
    }
    return false
}
func isDatePast(dateString: String?) -> Bool{
    if dateString == "" || dateString == nil {
        return false
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString!)
    let now = Date()
    if now > date! {
        return true
    }
    return false
}

// Tim display functions
func convertSecondsToClockString(seconds: Int) -> String {
    // Function to take the number of seconds and return the countdown clock format
    var clockString: String = "0:00"
    let min = Int( seconds / 60 )
    let sec = Int( seconds % 60 )
    if sec < 0 {
        if abs(sec) < 10 {
            clockString = "-\(abs(min)):0\(abs(sec))"
        }else{
            clockString = "-\(abs(min)):\(abs(sec))"
        }
    }else{
        if sec < 10 {
            clockString = "\(min):0\(sec)"
        }else{
            clockString = "\(min):\(sec)"
        }
    }
    return clockString
}

// Retrieve comon structured lists
func getCountries() -> [Country]{
    var countries = [Country]()
    guard let mainUrl = Bundle.main.url(forResource: "Countries", withExtension: "json") else {
        print("Couldn't retrieve the country list file")
        return []
    }
    do{
        let jsonData = try Data(contentsOf: mainUrl, options: .mappedIfSafe)
        let decoder = JSONDecoder()
        countries = try decoder.decode([Country].self, from: jsonData)
    } catch {
        print("Couldn't decode the json file")
        return []
    }
    return countries
}
func getHorns() -> [Horn]{
    var horns = [Horn]()
    horns.append( Horn( id: 0, fileName: "air", fileType: "wav", description: "Air Horn 1" ) )
    horns.append( Horn( id: 1, fileName: "sportsarena", fileType: "wav", description: "Sports Arena" ) )
    horns.append( Horn( id: 2, fileName: "ship", fileType: "wav", description: "Ship Horn" ) )
    horns.append( Horn( id: 3, fileName: "inception", fileType: "wav", description: "Inception Horn" ) )
    horns.append( Horn( id: 4, fileName: "epic", fileType: "wav", description: "Epic Horn" ) )
    return horns
}
func getVoices() -> [Voice]{
    var voices = [Voice]()
    let systemVoices = AVSpeechSynthesisVoice.speechVoices()
    // Create the arrays for 30 second speed up and twenty second speed up
    let thirty: [String] = [
        "com.apple.ttsbundle.Maged-compact",
        "com.apple.ttsbundle.Zuzana-compact",
        "com.apple.ttsbundle.Anna-compact",
        "com.apple.ttsbundle.siri_female_de-DE_compact",
        "com.apple.ttsbundle.siri_male_de-DE_compact",
        "com.apple.ttsbundle.Melina-compact",
        "com.apple.ttsbundle.Karen-premium",
        "com.apple.ttsbundle.Lee-premium",
        "com.apple.ttsbundle.siri_female_en-AU_compact",
        "com.apple.ttsbundle.Karen-compact",
        "com.apple.ttsbundle.Lee-compact",
        "com.apple.ttsbundle.Daniel-compact",
        "com.apple.ttsbundle.siri_female_en-GB_compact",
        "com.apple.ttsbundle.Moira-compact",
        "com.apple.ttsbundle.siri_female_en-US_compact",
        "com.apple.ttsbundle.Tessa-premium",
        "com.apple.ttsbundle.Tessa-compact",
        "com.apple.ttsbundle.Satu-compact",
        "com.apple.ttsbundle.Carmit-compact",
        "com.apple.ttsbundle.Mariska-compact",
        "com.apple.ttsbundle.Damayanti-compact",
        "com.apple.ttsbundle.Ellen-compact",
        "com.apple.ttsbundle.Zosia-compact",
        "com.apple.ttsbundle.Luciana-compact",
        "com.apple.ttsbundle.Joana-compact",
        "com.apple.ttsbundle.Ioana-compact",
        "com.apple.ttsbundle.Milena-compact",
        "com.apple.ttsbundle.Laura-compact",
        "com.apple.ttsbundle.Alva-compact",
        "com.apple.ttsbundle.Kanya-compact",
        "com.apple.ttsbundle.Yelda-compact",
        "com.apple.ttsbundle.siri_male_zh-CN_compact",
        "com.apple.ttsbundle.Ting-Ting-compact",
        "com.apple.ttsbundle.siri_female_zh-CN_compact",
    ]
    let twenty: [String] = [
        "com.apple.ttsbundle.Maged-compact",
        "com.apple.ttsbundle.Zuzana-compact",
        "com.apple.ttsbundle.Tessa-premium",
        "com.apple.ttsbundle.Satu-compact",
        "com.apple.ttsbundle.Mariska-compact",
        "com.apple.ttsbundle.Damayanti-compact",
        "com.apple.ttsbundle.Zosia-compact",
        "com.apple.ttsbundle.Ioana-compact",
        "com.apple.ttsbundle.Milena-compact",
        "com.apple.ttsbundle.Laura-compact",
        "com.apple.ttsbundle.siri_male_zh-CN_compact",
        "com.apple.ttsbundle.Ting-Ting-compact",
        "com.apple.ttsbundle.siri_female_zh-CN_compact",
    ]
    for voice in systemVoices {
        voices.append( Voice(code: voice.language,name: voice.name, identifier: voice.identifier, thirtySpeed: thirty.contains(voice.identifier), twentySpeed: twenty.contains(voice.identifier)) )
    }
    return voices
}
func getCurrentVoice() -> Voice{
    // Get the individual voice from the list of voices
    let voices = getVoices()
    let currentVoiceID = UserDefaults.standard.string( forKey: "audioVoice" ) ?? "com.apple.ttsbundle.Samantha-compact"
    var returnVoice: Voice!
    for voice in voices {
        if voice.identifier == currentVoiceID {
            returnVoice = voice
            break
        }
    }
    return returnVoice
}
func getLanguages() -> [(key: String, value: String)] {
    return [
        "en" : "English",
        "es" : "Spanish",
        ].sorted{$0.key < $1.key}
}
func getPrepTimes() -> [(key: Int, value: String)] {
    return [
        1 : "1 Minute",
        2 : "2 Minutes",
        3 : "3 Minutes",
        ].sorted{$0.key < $1.key}
}
func getVolumes() -> [(key: Float, value: String)] {
    return [
        0.0 : "0",
        0.1 : "1",
        0.2 : "2",
        0.3 : "3",
        0.4 : "4",
        0.5 : "5",
        0.6 : "6",
        0.7 : "7",
        0.8 : "8",
        0.9 : "9",
        1.0 : "10",
        ].sorted{$0.key < $1.key}
}

// Navigation routines
func navigateToView(viewName: String, viewSettings: VaultSettings) {
    // Function to navigate to a particular view
    if let window = UIApplication.shared.windows.first {
        switch viewName {
        case "Login":
            viewSettings.currentMainTab = Tab.home
            window.rootViewController = UIHostingController(rootView: LoginView().environmentObject(viewSettings))
        case "Home":
            viewSettings.currentMainTab = Tab.home
            window.rootViewController = UIHostingController(rootView: HomeView(pilot_id: viewSettings.pilot_id ).environmentObject(viewSettings))
        case "LocationList":
            viewSettings.currentMainTab = Tab.locations
            window.rootViewController = UIHostingController(rootView: LocationListView(discipline: viewSettings.search.event_type_code ?? "").environmentObject(viewSettings))
        case "LocationSearchParams":
            viewSettings.currentMainTab = Tab.locations
            window.rootViewController = UIHostingController(rootView: LocationSearchParamsView().environmentObject(viewSettings))
        case "PlaneList":
            viewSettings.currentMainTab = Tab.planes
            window.rootViewController = UIHostingController(rootView: PlaneListView().environmentObject(viewSettings))
        case "EventList":
            viewSettings.currentMainTab = Tab.events
            window.rootViewController = UIHostingController(rootView: EventListView().environmentObject(viewSettings))
        case "EventSearchParams":
            viewSettings.currentMainTab = Tab.events
            window.rootViewController = UIHostingController(rootView: EventSearchParamsView().environmentObject(viewSettings))
        case "PilotList":
            viewSettings.currentMainTab = Tab.pilots
            window.rootViewController = UIHostingController(rootView: PilotListView().environmentObject(viewSettings))
        case "PilotSearchParams":
            viewSettings.currentMainTab = Tab.pilots
            window.rootViewController = UIHostingController(rootView: PilotSearchParamsView().environmentObject(viewSettings))
        default:
            return
        }
        window.makeKeyAndVisible()
    }
    return
}

func navigateToLocationDetailView(location_id: Int, viewSettings: VaultSettings) {
    if let window = UIApplication.shared.windows.first {
        viewSettings.currentMainTab = Tab.locations
        window.rootViewController = UIHostingController(rootView: LocationDetailView(location_id: location_id).environmentObject(viewSettings))
        window.makeKeyAndVisible()
    }
    return
}
func navigateToPlaneDetailView(plane_id: Int, viewSettings: VaultSettings) {
    if let window = UIApplication.shared.windows.first {
        viewSettings.currentMainTab = Tab.planes
        window.rootViewController = UIHostingController(rootView: PlaneDetailView(plane_id: plane_id).environmentObject(viewSettings))
        window.makeKeyAndVisible()
    }
    return
}
func navigateToPilotDetailView(pilot_id: Int, viewSettings: VaultSettings) {
    if let window = UIApplication.shared.windows.first {
        viewSettings.currentMainTab = Tab.pilots
        window.rootViewController = UIHostingController(rootView: PilotDetailView(pilot_id: pilot_id).environmentObject(viewSettings))
        window.makeKeyAndVisible()
    }
    return
}
func navigateToEventDetailView(event_id: Int, viewSettings: VaultSettings) {
    if let window = UIApplication.shared.windows.first {
        viewSettings.currentMainTab = Tab.event_main
        window.rootViewController = UIHostingController(rootView: EventDetailView(event_id: event_id).environmentObject(viewSettings))
        window.makeKeyAndVisible()
    }
    return
}
func navigateToEventRoundView(round: Int, eventViewModel: EventDetailViewModel, viewSettings: VaultSettings) {
    if let window = UIApplication.shared.windows.first {
        viewSettings.currentMainTab = Tab.event_rounds
        window.rootViewController = UIHostingController(rootView: EventDetailRoundsView(round: round, eventViewModel: eventViewModel ).environmentObject(viewSettings))
        window.makeKeyAndVisible()
    }
    return
}

func navigateToEventView(viewName: String, eventViewModel: EventDetailViewModel, viewSettings: VaultSettings) {
    // Function to navigate to a particular view
    if let window = UIApplication.shared.windows.first {
        switch viewName {
        case "EventDetailRoundsView":
            viewSettings.currentMainTab = Tab.event_rounds
            window.rootViewController = UIHostingController(rootView: EventDetailRoundsView(round: 1, eventViewModel: eventViewModel ).environmentObject(viewSettings))
        case "EventDetailTasksView":
            viewSettings.currentMainTab = Tab.event_tasks
            window.rootViewController = UIHostingController(rootView: EventDetailTasksView(eventViewModel: eventViewModel ).environmentObject(viewSettings))
        case "EventDetailAudioView":
            viewSettings.currentMainTab = Tab.event_tasks
            window.rootViewController = UIHostingController(rootView: EventDetailAudioView(eventViewModel: eventViewModel ).environmentObject(viewSettings))
        case "EventDetailAudioPrefsView":
            viewSettings.currentMainTab = Tab.event_tasks
            window.rootViewController = UIHostingController(rootView: EventDetailAudioPrefsView(eventViewModel: eventViewModel ).environmentObject(viewSettings))
        case "EventDetailStatsView":
            viewSettings.currentMainTab = Tab.event_stats
            window.rootViewController = UIHostingController(rootView: EventDetailStatsView(eventViewModel: eventViewModel ).environmentObject(viewSettings))
        default:
            return
        }
        window.makeKeyAndVisible()
    }
    return
}
