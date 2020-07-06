//
//  ProfileView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/5/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct PilotDetailView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    var pilot_id: Int = 0
    @ObservedObject var pilotViewModel = PilotDetailViewModel(pilot_id: 0)
    init(pilot_id: Int){
        self.pilot_id = pilot_id
        loadModel()
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Pilot Detail")
                            .font(.title)
                            .fontWeight(.semibold)
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "PilotList", viewSettings: self.settings)
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
                VStack{
                    VStack{
                        // Start Main Content Here
                        // Either Using the scroll view or the vstack for control
                        // // // // // // // // // // // // // // // // //
                        //Main Content of view
                        // Pilot Info
                        Group{
                            HStack {
                                Text("Pilot Name")
                                    .padding(.leading, 5.0)
                                    .frame(width: 125, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.pilotViewModel.pilotInfo.pilot.pilot_first_name ?? "") \(self.pilotViewModel.pilotInfo.pilot.pilot_last_name ?? "")")
                                Spacer()
                            }.padding(1.0)
                            HStack {
                                Text("Pilot Location")
                                    .padding(.leading, 5.0)
                                    .frame(width: 125, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.pilotViewModel.pilotInfo.pilot.pilot_city ?? ""), \(self.pilotViewModel.pilotInfo.pilot.country_code ?? "") - " + getFlag(from: self.pilotViewModel.pilotInfo.pilot.country_code ?? "") )
                                Spacer()
                            }.padding(1.0)
                            HStack {
                                Text("Pilot AMA")
                                    .padding(.leading, 5.0)
                                    .frame(width: 125, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.pilotViewModel.pilotInfo.pilot.pilot_ama ?? "")")
                                Spacer()
                            }.padding(1.0)
                            HStack {
                                Text("Pilot FAI")
                                    .padding(.leading, 5.0)
                                    .frame(width: 125, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.pilotViewModel.pilotInfo.pilot.pilot_fai ?? "")")
                                Spacer()
                            }.padding(1.0)
                            HStack {
                                Text("Pilot FAI Lic")
                                    .padding(.leading, 5.0)
                                    .frame(width: 125, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.pilotViewModel.pilotInfo.pilot.pilot_fai_license ?? "")")
                                Spacer()
                            }.padding(1.0)
                        }
                        
                        ScrollView(.vertical){
                            // Pliot Plane List
                            Group{
                                HStack {
                                    Text("Pilot Planes")
                                        .padding(.leading, 5.0)
                                        .frame( height: 24.0, alignment: .leading )
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(.top, 2)
                                    .background(Color(.systemBlue))
                                
                                if self.pilotViewModel.pilotInfo.pilot.pilot_planes!.count > 0 {
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(alignment: .top, spacing: 1){
                                            ForEach(self.pilotViewModel.pilotInfo.pilot.pilot_planes ?? []){ plane in
                                                Button(action: {
                                                    // Navigate to detail
                                                    navigateToPlaneDetailView(plane_id: plane.plane_id ?? 0, viewSettings: self.settings)
                                                }) {
                                                    VStack(alignment: .leading, spacing: 1) {
                                                        HStack{
                                                            Image("f3xlogo")
                                                                .resizable()
                                                                .aspectRatio(1, contentMode: .fit)
                                                                .frame(width: 10)
                                                            Text("\(plane.plane_name!)")
                                                                .lineLimit(1)
                                                            Spacer()
                                                        }
                                                        Text("\(plane.pilot_plane_color!)")
                                                            .lineLimit(1)
                                                            .font(.system(size: 8))
                                                        if plane.pilot_plane_auw != 0{
                                                            Text( String(format: "%.02f", plane.pilot_plane_auw!)  + " \(plane.pilot_plane_auw_units!)")
                                                                .font(.system(size: 8))
                                                        }
                                                        Spacer()
                                                    }
                                                    .padding(.all)
                                                    .frame(width: 130.0)
                                                    .background(Color(.systemBlue).opacity(0.2))
                                                }
                                            }
                                        }
                                    }.frame(height: 45.0)
                                        .padding(.vertical, 0)
                                        .listRowInsets(EdgeInsets())
                                }else{
                                    HStack {
                                        Text("No Planes")
                                            .padding(.leading, 5.0)
                                            .frame( height: 24.0, alignment: .leading )
                                        Spacer()
                                    }.padding(.top, 1.0)
                                        .background(Color(.systemBlue).opacity(0.2))
                                        .padding(.bottom, 0.0)
                                }
                                
                            }.font(.system(size: 12))
                            
                            // Pliot Location List
                            Group{
                                HStack {
                                    Text("Pilot Locations")
                                        .padding(.leading, 5.0)
                                        .frame( height: 24.0, alignment: .leading )
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(1.0)
                                    .background(Color(.systemBlue))
                                if self.pilotViewModel.pilotInfo.pilot.pilot_locations!.count > 0 {
                                    ScrollView(.horizontal){
                                        HStack(alignment: .top, spacing: 1){
                                            ForEach(self.pilotViewModel.pilotInfo.pilot.pilot_locations ?? []){ location in
                                                Button(action: {
                                                    // Navigate to detail
                                                    navigateToLocationDetailView(location_id: location.location_id ?? 0, viewSettings: self.settings)
                                                }) {
                                                    VStack{
                                                        Text(getFlag(from: location.country_code ?? ""))
                                                        Text("\(location.location_name ?? "")")
                                                            .lineLimit(1)
                                                        Text("\(location.location_city ?? "")")
                                                            .lineLimit(1)
                                                        Spacer()
                                                    }
                                                    .padding(.all)
                                                    .frame(width: 130.0)
                                                    .background(Color(.systemBlue).opacity(0.2))
                                                }
                                                
                                            }
                                        }
                                    }.frame(height: 45.0)
                                }else{
                                    HStack {
                                        Text("No Locations")
                                            .padding(.leading, 5.0)
                                            .frame( height: 24.0, alignment: .leading )
                                        Spacer()
                                    }.padding(.top, 1.0)
                                        .background(Color(.systemBlue).opacity(0.2))
                                        .padding(.bottom, 0.0)
                                }
                            }.font(.system(size: 12))
                            
                            // Pliot Event List
                            Group{
                                HStack {
                                    Text("Pilot Events")
                                        .padding(.leading, 5.0)
                                        .frame( height: 24.0, alignment: .leading )
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(1.0)
                                    .background(Color(.systemBlue))
                                
                                HStack(alignment: .top, spacing: 1){
                                    Spacer()
                                        .frame(width: 30)
                                    Text("Date")
                                        .frame(width: 50)
                                    Text("Event Name")
                                    Spacer()
                                    Text("Place")
                                }
                                .background(Color(.systemBlue).opacity(0.2))
                                
                                ScrollView(.vertical){
                                    ForEach(self.pilotViewModel.pilotInfo.pilot.pilot_events ?? []){ event in
                                        HStack(alignment: .top){
                                            Text(getFlag(from: event.country_code ?? ""))
                                                .font(.system(size: 24))
                                                .frame(width: 30)
                                            Button(action: {
                                                navigateToEventDetailView(event_id: event.event_id!, viewSettings: self.settings)
                                                return
                                            }) {
                                                Text(showDate(dateString: event.event_start_date!))
                                                    .frame(width: 60)
                                                Text("\(event.event_name!)")
                                                Spacer()
                                                Text("\(event.event_pilot_position!)")
                                            }
                                        }
                                        .background(Color(.systemBlue).opacity(event.rowColor! ? 0.2 : 0 ))
                                        
                                    }
                                    Spacer()
                                }
                                .font(.system(size: 20))
                                Spacer()
                            }
                            Spacer()
                        }.font(.system(size: 16))
                        
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.85 )
                    .edgesIgnoringSafeArea(.bottom)
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.93 )
                Spacer()
            }
            ZStack{
                Spacer()
                VStack{
                    if self.pilotViewModel.networkIndicator {
                        ActivityIndicator(style: .large)
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height * 0.78 )
                
                Spacer()
                // Inclusion of Tab View
                BottomTabView( width: geometry.size.width, height: geometry.size.height )
            }.zIndex(1)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    mutating func loadModel(){
        pilotViewModel = PilotDetailViewModel(pilot_id: self.pilot_id)
    }
}


struct ProfileView_Previews: PreviewProvider {
    @EnvironmentObject var settings: VaultSettings
    static var previews: some View {
        PilotDetailView(pilot_id: 0).environmentObject(VaultSettings())
    }
}
