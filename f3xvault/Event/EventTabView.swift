//
//  EventTabView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/11/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI

struct EventTabView: View {
    @EnvironmentObject var settings: VaultSettings
    var eventViewModel: EventDetailViewModel
    
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    init( eventViewModel: EventDetailViewModel, width: CGFloat, height: CGFloat ){
        self.screenWidth = width
        self.screenHeight = height
        self.eventViewModel = eventViewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                
                Button(action: {
                    //action
                    navigateToView(viewName: "Home", viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "house.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Home")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 68)
                }.opacity(settings.currentMainTab == Tab.home ? 1 : 0.6 )
                
                Button(action: {
                    //action
                    navigateToEventDetailView(event_id: self.eventViewModel.event_id, viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Standings")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 68)
                }.opacity(settings.currentMainTab == Tab.event_main ? 1 : 0.6 )
                    .background(Color(.systemGreen))
                    .cornerRadius(12)
                
                Button(action: {
                    //action
                    navigateToEventView(viewName: "EventDetailRoundsView", eventViewModel: self.eventViewModel, viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "i.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Rounds")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 68)
                }.opacity(settings.currentMainTab == Tab.event_rounds ? 1 : 0.6 )
                    .background(Color(.systemGreen))
                    .cornerRadius(12)
                
                
                Button(action: {
                    //action
                    navigateToEventView(viewName: "EventDetailTasksView", eventViewModel: self.eventViewModel, viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "text.aligncenter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Tasks")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 68)
                }.opacity(settings.currentMainTab == Tab.event_tasks ? 1 : 0.6 )
                    .background(Color(.systemGreen))
                    .cornerRadius(12)
                
                
                Button(action: {
                    //action
                    navigateToEventView(viewName: "EventDetailStatsView", eventViewModel: self.eventViewModel, viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "number.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Stats")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 68)
                }.opacity(settings.currentMainTab == Tab.event_stats ? 1 : 0.6 )
                    .background(Color(.systemGreen))
                    .cornerRadius(12)
                
            }.foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
                .font(.system(size: 12))
                .frame(width: self.screenWidth, height: CGFloat.maximum( self.screenHeight/9, 60.0 ) )
                .background(Color(.systemBlue))
                .edgesIgnoringSafeArea(.bottom)
        }
        
    }
    
}

struct EventTabView_Previews: PreviewProvider {
    static var previews: some View {
        EventTabView(eventViewModel: EventDetailViewModel(event_id: 0), width: 400.0, height: 800.0).environmentObject(VaultSettings())
    }
}
