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
    
    var audioPlayer = AVAudioPlayer()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Audio Tasks")
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
                            Text("Event Type")
                                .padding(.leading, 5.0)
                                .frame(width: 125, height: 24.0, alignment: .leading )
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                            Text("\(self.eventViewModel.eventInfo.event.event_type_name) ")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        .padding(1.0)
                    }
                    // Actual Audio player buttons and bar
                    Group{
                        Spacer()
                        
                        HStack{
                            Capsule()
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 20)
                        }
                        .frame(height: 20)
                        
                        HStack(spacing: geometry.size.width / 5 - 30){
                            Button(action: {
                                //Action
                            }) {
                                Image(systemName: "backward.fill")
                                    .font(.title)
                            }
                            Button(action: {
                                //Action
                            }) {
                                Image(systemName: "gobackward.15")
                                    .font(.title)
                            }
                            Button(action: {
                                //Action
                            }) {
                                Image(systemName: "play.fill")
                                    .font(.title)
                            }
                            Button(action: {
                                //Action
                            }) {
                                Image(systemName: "goforward.15")
                                    .font(.title)
                            }
                            Button(action: {
                                //Action
                            }) {
                                Image(systemName: "forward.fill")
                                    .font(.title)
                            }
                        }
                        .frame(height: 70)
                        
                    }
                    Spacer()
                        .frame(height: 0.1)
                    // Event Standings List
                    Group{
                        ScrollView{
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
                            
                            // Task List
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
                            VStack{
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
}

struct EventDetailAudioView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailAudioView(eventViewModel: EventDetailViewModel(event_id: 0))
    }
}
