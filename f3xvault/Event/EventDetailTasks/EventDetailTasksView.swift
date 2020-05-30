//
//  EventDetailTasksView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/25/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI

struct EventDetailTasksView: View {
    var eventViewModel: EventDetailViewModel
    @EnvironmentObject var settings: VaultSettings
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Event Tasks")
                            .font(.title)
                            .fontWeight(.semibold)
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "EventList", viewSettings: self.settings)
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
                            Text("Location")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text(getFlag(from: self.eventViewModel.eventInfo.event.country_code))
                                .frame(width: 20)
                            Text(" - \(self.eventViewModel.eventInfo.event.country_code) - ")
                                .font(.system(size: 12))
                            Text("\(self.eventViewModel.eventInfo.event.location_name) ")
                                .font(.system(size: 12))
                            Spacer()
                        }.padding(1.0)
                        HStack {
                            Text("Start Date")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.start_date) ")
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
                        }.padding(1.0)
                    }
                    
                    if self.eventViewModel.eventInfo.event.event_type_code == "f3k" || self.eventViewModel.eventInfo.event.event_type_code == "f3j" || self.eventViewModel.eventInfo.event.event_type_code == "f5j" {
                        // Button to go to timing screen
                        Button(action: {
                            //action to go to round audio playlist
                            navigateToEventView(viewName: "EventDetailAudioView", eventViewModel: self.eventViewModel, viewSettings: self.settings)
                            return
                        }) {
                            // Button Label
                            HStack{
                                Spacer()
                                    .frame(width: 20.0)
                                Image(systemName: "speaker.2")
                                    .font(.system(size: 30))
                                    .frame(width: 30)
                                Spacer()
                                    .frame(width: 20.0)
                                Text("Audio Playlist")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.white))
                                    .frame(width: 200)
                                Spacer()
                            }
                            .frame(width: 300.0, height: 50.0)
                            .background(Color(.systemGreen))
                            .cornerRadius(10)
                            
                        }
                        Spacer()
                    }
                    HStack{
                        HStack {
                            Text("Event Tasks")
                                .padding(.leading, 5.0)
                                .frame( height: 24.0, alignment: .leading )
                            Spacer()
                        }.padding(.top, 2.0)
                            .background(Color(.systemBlue))
                            .foregroundColor(.white)
                    }
                    HStack(alignment: .top){
                        Text("Rnd")
                            .frame(width: 25)
                        Text("Task Code")
                            .frame(width: 70)
                        Spacer()
                            .frame(width: 5)
                        Text("Task Description")
                        Spacer()
                    }
                    .font(.system(size: 12))
                    .background(Color(.systemBlue).opacity(0.2))

                    Spacer()
                        .frame(height: 0.1)
                    // Event Standings List
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
                                                .frame(width: 25)
                                                .foregroundColor(Color(.black))
                                            HStack{
                                                Text("\(task.flight_type_code)")
                                                    .font(.system(size: 11))
                                                    .frame(width: 70)
                                                Spacer()
                                            }
                                            .frame(width: 70)
                                            Spacer()
                                                .frame(width: 5)
                                            Text("\(task.flight_type_name)")
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        .frame(width: geometry.size.width)
                                        .background(Color(.systemBlue).opacity(task.rowColor ?? false ? 0.2 : 0 ))
                                        .foregroundColor(Color(.systemBlue))
                                        
                                        HStack(alignment: .top){
                                            Text("")
                                                .frame(width: 110)
                                            Text("\(task.flight_type_description)")
                                                .font(.system(size: 14))
                                                .foregroundColor(.black)
                                        }
                                        .frame(width: geometry.size.width)
                                        .background(Color(.systemBlue).opacity(task.rowColor ?? false ? 0.2 : 0 ))
                                        .padding(.bottom, 1)
                                    }
                                }
                                Spacer()
                                    .frame(height: 20)
                            }
                            
                        }
                        .font(.system(size: 16))
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65 )
                    
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
}

struct EventDetailTasksView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailTasksView(eventViewModel: EventDetailViewModel(event_id: 0))
    }
}
