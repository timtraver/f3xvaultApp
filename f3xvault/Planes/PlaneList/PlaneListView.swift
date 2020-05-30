//
//  PlaneView.swift
//  f3xvault
//
//  Created by Timothy Traver on 3/28/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct PlaneListView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    @ObservedObject var planeList = PlaneSearchViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var numberRecords = 0
    @State private var showParamLink: Bool = true
    
    var totalRecords: Int { self.planeList.planeList.planes?.count ?? 0 }
    var calcRecords: Int { self.filterList(list: self.planeList.planeList.planes ?? [], string: self.searchText ).count }
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack(alignment: .leading){
                    HStack(alignment: .bottom) {
                        VStack{
                            Spacer()
                                .frame(height: 30)
                            Text("Planes")
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(width: 200, alignment: .leading)
                        }
                        Spacer()
                        VStack{
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
                        .frame(height: 10)
                    HStack(alignment: .top, spacing: 1){
                        Spacer()
                            .frame(width: 40)
                        Text("Plane Name")
                            .foregroundColor(.white)
                        Spacer()
                        Text("Max FAI Weight")
                            .foregroundColor(.white)
                            .padding(.trailing, 2.0)
                    }
                    .background(Color(.systemBlue).opacity(0.5))
                    .frame(height: 0.01)
                    
                    ScrollView(.vertical){
                        // Start Main Content Here
                        // Either Using the scroll view or the vstack for control
                        // // // // // // // // // // // // // // // // //
                        Rectangle()
                            .frame(width: geometry.size.width, height: 0.01)
                        
                        // Main Content of view
                        ForEach(self.filterList(list: self.planeList.planeList.planes ?? [], string: self.searchText )){ plane in
                            HStack{
                                Text(getFlag(from: plane.country_code ?? ""))
                                    .frame(width: 30)
                                Button(action: {
                                    // Navigate to detail
                                    navigateToPlaneDetailView(plane_id: plane.plane_id ?? 0, viewSettings: self.settings)
                                }) {
                                    Text("\(plane.plane_name!)")
                                    Spacer()
                                    if plane.plane_max_g != 0 {
                                        Text(String(format: "%.0f", plane.plane_max_g!))
                                    }
                                }                                
                            }
                            .background(Color(.systemBlue).opacity(plane.rowColor! ? 0.2 : 0 ))
                            
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
                    if self.planeList.networkIndicator {
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
    
    func filterList(list: [PlaneInfo], string: String ) -> [PlaneInfo]{
        // function to filter the list based on the string that has been entered
        var returnList: [PlaneInfo] = []
        var colorRow: Bool = false
        for var plane in list{
            var exclude = 0
            
            // Start out with the exclude filter variables first
            //Country
            if self.settings.search.country == " " || self.settings.search.country == "  " {
                self.settings.search.country = ""
            }
            if self.settings.search.country != "" && plane.country_code != self.settings.search.country {
                exclude = 1
            }
            
            if string != "" && !((plane.plane_name?.lowercased().contains(string.lowercased()))!){
                exclude = 1
            }
            if exclude == 0 {
                colorRow.toggle()
                plane.rowColor = colorRow
                returnList.append(plane)
            }
        }
        return returnList
    }
    
    // Uncomment this to load the initial model if it has parameters for the view
    //mutating func loadModel(){
    //    viewModel = PilotViewModel(pilot_id: self.pilot_id)
    //}
}

struct PlaneListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaneListView().environmentObject(VaultSettings())
    }
}
