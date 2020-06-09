//
//  LocationListView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/15/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct LocationListView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    var discipline: String = ""
    // Use this section to load the Model View for this View
    @ObservedObject var locationList = LocationSearchViewModel(discipline: "")
    
    init(discipline: String){
        self.discipline = discipline
        loadModel()
    }
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var numberRecords = 0
    @State private var showParamLink: Bool = true
    
    var totalRecords: Int { self.locationList.locationList.total_records ?? 0 }
    var calcRecords: Int { self.filterList(list: self.locationList.locationList.locations ?? [], string: self.searchText ).count }
    var activeFilters: Bool { self.settings.search.event_type_code != "" || self.settings.search.country != "" }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack(alignment: .leading){
                    HStack(alignment: .bottom){
                        VStack{
                            Spacer()
                                .frame(height: 30)
                            Text("Locations")
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(width: 200, alignment: .leading)
                        }
                        Spacer()
                        VStack{
                            HStack(alignment: .top){
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "LocationSearchParams", viewSettings: self.settings)
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
                            .padding(.bottom, 8)
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
                        Text("Location Name")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .background(Color(.systemBlue).opacity(0.5))
                    .frame(height: 0.01)
                    .font(.system(size: 18))

                    List{
                        // Start Main Content Here
                        // Either Using the scroll view or the vstack for control
                        // // // // // // // // // // // // // // // // //
                        
                        // Main Content of view
                        ForEach(self.filterList(list: self.locationList.locationList.locations ?? [], string: self.searchText )){ location in
                            HStack{
                                Text(getFlag(from: location.country_code ?? ""))
                                    .frame(width: 30)
                                
                                Button(action: {
                                    // Navigate to detail
                                    navigateToLocationDetailView(location_id: location.location_id ?? 0, viewSettings: self.settings)
                                }) {
                                    Text("\(location.location_name!)")
                                }
                                
                                Spacer()
                            }
                            .font(.system(size: 22))
                            .padding(0)
                            .listRowBackground(Color(.systemBlue).opacity(location.rowColor! ? 0.2 : 0 ))
                            .frame(height: 30)
                        }
                        
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }
                        .id(UUID())
                        .padding(.horizontal, -20)
                        .padding(.vertical, 0)
                        .environment(\.defaultMinListRowHeight, 20)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.78 )
                        .edgesIgnoringSafeArea(.bottom)
                        .onAppear(){
                                UITableView.appearance().separatorStyle = .none
                        }
                }
                
            }.frame(width: geometry.size.width, height: geometry.size.height * 0.88 )
            
            ZStack{
                VStack{
                    if self.locationList.networkIndicator {
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
    
    func filterList(list: [LocationInfo], string: String ) -> [LocationInfo]{
        // function to filter the list based on the string that has been entered
        var returnList: [LocationInfo] = []
        var colorRow: Bool = false
        for var location in list{
            var exclude = 0
            
            // Start out with the exclude filter variables first
            //Country
            if self.settings.search.country == " " || self.settings.search.country == "  " {
                self.settings.search.country = ""
            }
            if self.settings.search.country != "" && location.country_code != self.settings.search.country {
                exclude = 1
            }
            
            if string != "" && !((location.location_name?.lowercased().contains(string.lowercased()))!){
                exclude = 1
            }
            if exclude == 0 {
                colorRow.toggle()
                location.rowColor = colorRow
                returnList.append(location)
            }
        }
        return returnList
    }
    
    // Uncomment this to load the initial model if it has parameters for the view
    mutating func loadModel(){
        locationList = LocationSearchViewModel(discipline: self.discipline)
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView(discipline: "").environmentObject(VaultSettings())
    }
}
