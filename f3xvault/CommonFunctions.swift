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

func getFlag(from countryCode: String) -> String {
    return countryCode
        .unicodeScalars
        .map({ 127397 + $0.value })
        .compactMap(UnicodeScalar.init)
        .map(String.init)
        .joined()
}

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
