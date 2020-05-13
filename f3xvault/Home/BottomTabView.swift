//
//  BottomTabView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI

struct BottomTabView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    init( width: CGFloat, height: CGFloat ){
        self.screenWidth = width
        self.screenHeight = height
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .top){
                
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
                    }.frame(width: self.screenWidth/6, height: 70)
                }
                .padding(.vertical, 0.0)
                .opacity(settings.currentMainTab == Tab.home ? 1 : 0.6 )
                
                Button(action: {
                    //action
                    navigateToView(viewName: "EventList", viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Events")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 70)
                }.opacity(settings.currentMainTab == Tab.events ? 1 : 0.6 )
                
                Button(action: {
                    //action
                    navigateToView(viewName: "LocationList", viewSettings: self.settings)
                    self.settings.currentMainTab = Tab.locations
                }) {
                    VStack{
                        Image(systemName: "globe")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Locations")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 70)
                }.opacity(settings.currentMainTab == Tab.locations ? 1 : 0.6 )
                
                Button(action: {
                    //action
                    navigateToView(viewName: "PlaneList", viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "airplane")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Planes")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 70)
                }.opacity(settings.currentMainTab == Tab.planes ? 1 : 0.6 )
                
                Button(action: {
                    //action
                    navigateToView(viewName: "PilotList", viewSettings: self.settings)
                    return
                }) {
                    VStack{
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding([.top, .leading, .trailing], 8)
                        Text("Pilots")
                            .padding(0)
                        Spacer()
                    }.frame(width: self.screenWidth/6, height: 70)
                }.opacity(settings.currentMainTab == Tab.pilots ? 1 : 0.6 )
                
            }.foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
                .font(.system(size: 12))
                .frame(width: self.screenWidth, height: CGFloat.maximum( self.screenHeight/9, 60.0 ) )
                .background(Color(.systemBlue).shadow(radius: 2))
                .edgesIgnoringSafeArea(.bottom)
            
        }
    }
    
}

struct BottomTabView_Previews: PreviewProvider {
    @EnvironmentObject var settings: VaultSettings
    static var previews: some View {
        BottomTabView(width: 400.0, height: 800.0).environmentObject(VaultSettings())
    }
}
