//
//  SwiftUIView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct EventListView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    @ObservedObject var eventList = EventSearchViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var numberRecords = 0
    @State private var showParamLink: Bool = true
    
    var totalRecords: Int { self.eventList.eventList.total_records ?? 0 }
    var calcRecords: Int { self.filterList(list: self.eventList.eventList.events ?? [], string: self.searchText ).count }
    var activeFilters: Bool { self.settings.search.use_dates! || self.settings.search.event_type_code != "" || self.settings.search.country != "" }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack(alignment: .leading){
                    HStack(alignment: .bottom){
                        VStack{
                            Spacer()
                                .frame(height: 30)
                            Text("Events")
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(width: 225, alignment: .leading)
                        }
                        Spacer()
                        VStack{
                            HStack(alignment: .top){
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "EventSearchParams", viewSettings: self.settings)
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
                                Text(String(self.calcRecords) + NSLocalizedString(" of ", comment: "Of") + String(self.totalRecords))
                                    .font(.system(size: 10))
                            }
                            .padding(.bottom, 8)
                        }
                        .frame(height: 25)
                        .padding(.trailing, 5)
                    }
                    .padding(.leading, 5)
                }
                .frame(height: 40)
                
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
                            .frame(width: 35)
                        Text("Date")
                            .frame(width: 70)
                        Text("Event Name")
                        Spacer()
                    }
                    .background(Color(.systemBlue).opacity(0.5))
                    .frame(height: 1)
                    .font(.system(size: 18))
                    
                    List{
                        // Start Main Content Here
                        // Either Using the scroll view or the vstack for control
                        // // // // // // // // // // // // // // // // //

                        //Main Content of view
                        ForEach(self.filterList(list: self.eventList.eventList.events ?? [], string: self.searchText )){ event in
                            HStack(alignment: .top){
                                Text(getFlag(from: event.country_code ?? ""))
                                    .font(.system(size: 24))
                                Button(action: {
                                    // Navigate to the event detail
                                    navigateToEventDetailView(event_id: event.event_id ?? 0, viewSettings: self.settings)
                                    return
                                }) {
                                    HStack{
                                        Text(showDate(dateString: event.event_start_date ?? "") )
                                            .frame(width: 65)
                                        Text("\(event.event_name!)")
                                        Spacer()
                                    }
                                }
                            }
                            .font(.system(size: 22))
                            .padding(0)
                            .listRowBackground(Color(.systemBlue).opacity(event.rowColor! ? 0.2 : 0 ))
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
                    if self.eventList.networkIndicator {
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
    
    func filterList(list: [EventSearchInfo], string: String ) -> [EventSearchInfo]{
        // function to filter the list based on the string that has been entered
        var returnList: [EventSearchInfo] = []
        var colorRow: Bool = false
        for var event in list{
            var exclude = 0
            
            // Start out with the exclude filter variables first
            //Country
            if self.settings.search.country == " " || self.settings.search.country == "  " {
                self.settings.search.country = ""
            }
            if self.settings.search.country != "" && event.country_code != self.settings.search.country {
                exclude = 1
            }
            if self.settings.search.event_type_code != "" && event.event_type_code != self.settings.search.event_type_code {
                if self.settings.search.event_type_code == "f3f" && event.event_type_code == "f3f_plus" && exclude == 0 {
                    exclude = 0
                }else{
                    exclude = 1
                }
            }
            //Check the dates if we need to
            if self.settings.search.use_dates == true {
                // Lets turn the date of the event into a date object
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let eventDate = dateFormatter.date(from: event.event_start_date ?? "2000-01-01" )
                if eventDate! < self.settings.search.date_from || eventDate! > self.settings.search.date_to {
                    exclude = 1
                }
            }
            
            if string != "" && !((event.event_name?.lowercased().contains(string.lowercased()))!){
                exclude = 1
            }
            if exclude == 0 {
                colorRow.toggle()
                event.rowColor = colorRow
                returnList.append(event)
            }
        }
        return returnList
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView().environmentObject(VaultSettings())
    }
}
