//
//  PilotListView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/18/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct PilotListView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    @ObservedObject var pilotList = PilotSearchViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var numberRecords = 0
    @State private var showParamLink: Bool = true
    
    var totalRecords: Int { self.pilotList.pilotList.total_records ?? 0 }
    var calcRecords: Int { self.filterList(list: self.pilotList.pilotList.pilots ?? [], string: self.searchText ).count }
    var activeFilters: Bool { self.settings.search.event_type_code != "" || self.settings.search.country != "" }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack(alignment: .leading){
                    HStack(alignment: .bottom) {
                        VStack{
                            Spacer()
                                .frame(height: 30)
                            Text("Pilots")
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(width: 200, alignment: .leading)
                        }
                        Spacer()
                        VStack{
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "PilotSearchParams", viewSettings: self.settings)
                                    return
                                }) {
                                    Text(self.activeFilters ? "Active Filters" : "Set Filters")
                                        .foregroundColor(self.activeFilters ? .red : .blue)
                                    Image(systemName: "chevron.right")
                                        .padding(.trailing, 5)
                                }
                            }
                            HStack{
                                Spacer()
                                Text("Total Records : ")
                                    .font(.system(size: 10))
                                Text(String(self.calcRecords) + " of " + String(self.totalRecords))
                                    .font(.system(size: 10))
                            }
                        }
                        .frame(height: 25)
                        .padding(.trailing, 5)
                    }
                    .padding(.leading, 5)
                }.frame(height: 40)
                
                // Main VStack Content Frame
                VStack{
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                            TextField("search", text: self.$searchText, onEditingChanged: { isEditing in
                                self.showCancelButton = true
                            }, onCommit: {
                            }).foregroundColor(.primary)
                            
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.secondary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10.0)
                        
                        if self.showCancelButton  {
                            Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchText = ""
                                self.showCancelButton = false
                            }
                            .foregroundColor(Color(.systemBlue))
                        }
                    }
                    .padding(.horizontal)
                        .navigationBarHidden(self.showCancelButton) // .animation(.default) // animation does not work properly
                    
                    Spacer()
                        .frame(height: 5)
                    HStack(alignment: .top, spacing: 1){
                        Spacer()
                            .frame(width: 40)
                        Text("Pilot Name")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .background(Color(.systemBlue).opacity(0.5))
                    .frame(height: 0.01)
                    .font(.system(size: 18))

                    ScrollView(.vertical){
                        // Start Main Content Here
                        // Either Using the scroll view or the vstack for control
                        // // // // // // // // // // // // // // // // //
                        Rectangle()
                            .frame(width: geometry.size.width, height: 0.01)
                        
                        // Main Content of view
                        ForEach(self.filterList(list: self.pilotList.pilotList.pilots ?? [], string: self.searchText )){ pilot in
                            HStack{
                                Text(getFlag(from: pilot.country_code ?? ""))
                                    .frame(width: 30)
                                
                                Button(action: {
                                    // Navigate to detail
                                    navigateToPilotDetailView(pilot_id: pilot.pilot_id ?? 0, viewSettings: self.settings)
                                    return
                                }) {
                                    Text("\(pilot.pilot_first_name!) \(pilot.pilot_last_name!)")
                                }
                                
                                Spacer()
                            }
                            .background(Color(.systemBlue).opacity(pilot.rowColor! ? 0.2 : 0 ))
                            
                        }
                        
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }.font(.system(size: 22))
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.78 )
                        .edgesIgnoringSafeArea(.bottom)
                }
                
            }.frame(width: geometry.size.width, height: geometry.size.height * 0.88 )
            
            ZStack{
                VStack{
                    if self.pilotList.networkIndicator {
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
    
    func filterList(list: [PilotInfo], string: String ) -> [PilotInfo]{
        // function to filter the list based on the string that has been entered
        var returnList: [PilotInfo] = []
        var colorRow: Bool = false
        for var pilot in list{
            var exclude = 0
            
            // Start out with the exclude filter variables first
            //Country
            if self.settings.search.country == " " || self.settings.search.country == "  " {
                self.settings.search.country = ""
            }
            if self.settings.search.country != "" && pilot.country_code != self.settings.search.country {
                exclude = 1
            }
            
            if string != "" && !((pilot.pilot_first_name?.lowercased().contains(string.lowercased()))! && !((pilot.pilot_last_name?.lowercased().contains(string.lowercased()))! )){
                exclude = 1
                
            }
            if exclude == 0 {
                colorRow.toggle()
                pilot.rowColor = colorRow
                returnList.append(pilot)
            }
        }
        return returnList
    }
    
}

struct PilotListView_Previews: PreviewProvider {
    static var previews: some View {
        PilotListView().environmentObject(VaultSettings())
    }
}
