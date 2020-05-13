//
//  HomeView.swift
//  f3xvault
//
//  Created by Timothy Traver on 3/28/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeView: View {
    var pilot_id: Int = 0
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    @ObservedObject var currentPilot = HomeViewModel(pilot_id: 0)
    init(pilot_id: Int){
        self.pilot_id = pilot_id
        loadPilotModel()
    }
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                // Main VStack Content Frame
                VStack{
                    ScrollView{
                        // Start Main Content Here
                        // Either Using the scroll view or the vstack for control
                        // // // // // // // // // // // // // // // // //
                        
                        //Main Content of view
                        VStack(alignment: .center) {
                            
                            Spacer()
                                .frame(height:20)
                            if self.settings.user_first_name != "" {
                                Text("Welcome \(self.settings.user_first_name) !")
                            }else{
                                Text("Welcome Guest !")
                            }
                            if self.settings.country_code != "" {
                                Text(getFlag(from: self.settings.country_code))
                                    .font(.system(size: 90))
                            }
                            Spacer()
                                .frame(height:10)
                            
                            
                            if self.currentPilot.atEvent != 0 {
                                Button(action: {
                                    // Action Here
                                    navigateToEventDetailView(event_id: self.currentPilot.atEvent, viewSettings: self.settings)
                                    return
                                }) {
                                    HStack{
                                        Spacer()
                                            .frame(width: 20.0)
                                        Text("Take Me To Todays Event!")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.white))
                                            .frame(width: 250)
                                        Spacer()
                                    }
                                    .frame(width: 300.0, height: 40.0)
                                    .background(Color(.systemGreen))
                                    .cornerRadius(10)
                                }
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 20)
                            }else if self.currentPilot.lastEvent != 0 {
                                Button(action: {
                                    // Action Here
                                    navigateToEventDetailView(event_id: self.currentPilot.lastEvent, viewSettings: self.settings)
                                    return
                                }) {
                                    HStack{
                                        Spacer()
                                            .frame(width: 20.0)
                                        Text("Show Me My Last Event")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.white))
                                            .frame(width: 250)
                                        Spacer()
                                    }
                                    .frame(width: 300.0, height: 40.0)
                                    .background(Color(.systemGreen))
                                    .cornerRadius(10)
                                }
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 20)
                            }
                            
                            
                            
                            Group{
                                if self.settings.pilot_id != 0 {
                                    Button(action: {
                                        // Action Here
                                        navigateToPilotDetailView(pilot_id: self.settings.pilot_id, viewSettings: self.settings)
                                        return
                                    }) {
                                        HStack{
                                            Spacer()
                                                .frame(width: 20.0)
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 30))
                                                .frame(width: 30)
                                            Spacer()
                                                .frame(width: 20.0)
                                            Text("View My Profile")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color(.white))
                                                .frame(width: 200)
                                            Spacer()
                                        }
                                        .frame(width: 300.0, height: 40.0)
                                        .background(Color(.systemBlue))
                                        .cornerRadius(10)
                                    }
                                    .foregroundColor(Color(.white))
                                    .padding(.horizontal, 20)
                                }
                                Button(action: {
                                    // Action Here
                                    navigateToView(viewName: "EventList", viewSettings: self.settings)
                                    return
                                }
                                ) {
                                    HStack{
                                        Spacer()
                                            .frame(width: 20.0)
                                        Image(systemName: "paperplane.fill")
                                            .font(.system(size: 30))
                                            .frame(width: 30)
                                        Spacer()
                                            .frame(width: 20.0)
                                        Text("Browse Events")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.white))
                                            .frame(width: 200)
                                        Spacer()
                                    }
                                    .frame(width: 300.0, height: 40.0)
                                    .background(Color(.systemBlue))
                                    .cornerRadius(10)
                                }
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 20)
                                
                                Button(action: {
                                    // Action Here
                                    navigateToView(viewName: "LocationList", viewSettings: self.settings)
                                    return
                                }
                                ) {
                                    HStack{
                                        Spacer()
                                            .frame(width: 20.0)
                                        Image(systemName: "globe")
                                            .font(.system(size: 30))
                                            .frame(width: 30)
                                        Spacer()
                                            .frame(width: 20.0)
                                        Text("Browse Locations")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.white))
                                            .frame(width: 200)
                                        Spacer()
                                    }
                                    .frame(width: 300.0, height: 40.0)
                                    .background(Color(.systemBlue))
                                    .cornerRadius(10)
                                }
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 20)
                                
                                Button(action: {
                                    // Action Here
                                    navigateToView(viewName: "PlaneList", viewSettings: self.settings)
                                    return
                                }
                                ) {
                                    HStack{
                                        Spacer()
                                            .frame(width: 20.0)
                                        Image(systemName: "airplane")
                                            .font(.system(size: 30))
                                            .frame(width: 30)
                                        Spacer()
                                            .frame(width: 20.0)
                                        Text("Browse Planes")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.white))
                                            .frame(width: 200)
                                        Spacer()
                                    }
                                    .frame(width: 300.0, height: 40.0)
                                    .background(Color(.systemBlue))
                                    .cornerRadius(10)
                                }
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 20)
                                
                                Button(action: {
                                    // Action Here
                                    navigateToView(viewName: "PilotList", viewSettings: self.settings)
                                    return
                                }) {
                                    HStack{
                                        Spacer()
                                            .frame(width: 20.0)
                                        Image(systemName: "person")
                                            .font(.system(size: 30))
                                            .frame(width: 30)
                                        Spacer()
                                            .frame(width: 20.0)
                                        Text("Browse Pilots")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.white))
                                            .frame(width: 200)
                                        Spacer()
                                    }
                                    .frame(width: 300.0, height: 40.0)
                                    .background(Color(.systemBlue))
                                    .cornerRadius(10)
                                }
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 20)
                                
                                
                                Button(action: {
                                    // Action Here
                                    navigateToView(viewName: "Login", viewSettings: self.settings)
                                    return
                                }
                                ) {
                                    HStack{
                                        Spacer()
                                            .frame(width: 20.0)
                                        Image(systemName: "eject")
                                            .font(.system(size: 30))
                                            .frame(width: 30)
                                        Spacer()
                                            .frame(width: 20.0)
                                        Text("Log Out")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.white))
                                            .frame(width: 200)
                                        Spacer()
                                    }
                                    .frame(width: 300.0, height: 40.0)
                                    .background(Color(.systemBlue))
                                    .cornerRadius(10)
                                }
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 20)
                                
                            }
                        }
                        Spacer()
                        
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.83 )
                    .edgesIgnoringSafeArea(.bottom)
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.88 )
                // Inclusion of Tab View
                
                BottomTabView( width: geometry.size.width, height: geometry.size.height )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
    mutating func loadPilotModel(){
        self.currentPilot = HomeViewModel(pilot_id: self.pilot_id)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(pilot_id: 0).environmentObject(VaultSettings())
    }
}
