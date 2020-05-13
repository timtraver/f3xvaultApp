//
//  LocationDetailView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/16/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    var location_id: Int = 0
    @ObservedObject var locationModel = LocationDetailViewModel(location_id: 0)
    init(location_id: Int){
        self.location_id = location_id
        loadLocationDetailModel()
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Location Detail")
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(width: 250, alignment: .leading)
                        Spacer()
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "LocationList", viewSettings: self.settings)
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
                        // Location Info
                        Group{
                            HStack(alignment: .top) {
                                Text("Location Name")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.locationModel.locationInfo.location?.location_name ?? "")")
                                Spacer()
                            }.padding(1.0)
                            HStack(alignment: .top) {
                                Text("Location City")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.locationModel.locationInfo.location?.location_city ?? ""), \(self.locationModel.locationInfo.location?.country_code ?? "") - " + getFlag(from: self.locationModel.locationInfo.location?.country_code ?? "") )
                                Spacer()
                            }.padding(1.0)
                            HStack(alignment: .top) {
                                Text("Location Club")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.locationModel.locationInfo.location?.location_club ?? "")")
                                Spacer()
                            }.padding(1.0)
                            HStack(alignment: .top) {
                                Text("Club URL")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                if self.locationModel.locationInfo.location?.location_club_url != "" {
                                    Button(action: {
                                        // Opne the link to the website in a browser
                                        UIApplication.shared.open(URL(string: self.locationModel.locationInfo.location?.location_club_url ?? "" )!)
                                    }) {
                                        Text("\(self.locationModel.locationInfo.location?.location_club_url ?? "")")
                                            .font(.system(size: 12))
                                    }
                                }
                                Spacer()
                            }.padding(1.0)
                            HStack(alignment: .top) {
                                Text("Coordinates")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.locationModel.locationInfo.location?.location_coordinates ?? "")")
                                    .font(.system(size: 12))
                                if self.locationModel.locationInfo.location?.location_coordinates != "" {
                                    Button(action: {
                                        // action
                                        let parts = self.locationModel.locationInfo.location?.location_coordinates?.components(separatedBy: ",");
                                        let lat = Double(parts![0].trimmingCharacters(in: .whitespacesAndNewlines))
                                        let lon = Double(parts![1].trimmingCharacters(in: .whitespacesAndNewlines))
                                        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: lon!)))
                                        source.name = "\(self.locationModel.locationInfo.location?.location_name ?? "")"
                                        MKMapItem.openMaps(with: [source])
                                    }) {
                                        
                                        HStack{
                                            Text("Launch Map")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color(.white))
                                                .frame(width: 100)
                                        }
                                        .frame(width: 100.0, height: 50.0)
                                        .background(Color(.systemGreen))
                                        .cornerRadius(10)
                                        
                                    }
                                }
                                Spacer()
                            }.padding(1.0)
                            HStack(alignment: .top) {
                                Text("Flying Types")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                VStack(alignment: .leading){
                                    ForEach(self.locationModel.locationInfo.location?.disciplines ?? []){ disc in
                                        Text("\(disc.discipline_description ?? "")")
                                            .font(.system(size: 12))
                                    }
                                }
                                Spacer()
                            }.padding(1.0)
                            
                        }
                        Group{
                            HStack(alignment: .top) {
                                Text("Description")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.locationModel.locationInfo.location?.location_description ?? "")")
                                Spacer()
                            }.padding(1.0)
                            HStack(alignment: .top) {
                                Text("Directions")
                                    .padding(.leading, 5.0)
                                    .frame(width: 140, height: 24.0, alignment: .leading )
                                    .background(Color(.systemBlue))
                                    .foregroundColor(.white)
                                Text("\(self.locationModel.locationInfo.location?.location_directions ?? "")")
                                Spacer()
                            }.padding(1.0)
                            
                            // Event list if there is any
                            HStack {
                                Text("Location Events")
                                    .padding(.leading, 5.0)
                                    .frame( height: 24.0, alignment: .leading )
                                    .foregroundColor(.white)
                                Spacer()
                            }.padding(1.0)
                                .background(Color(.systemBlue))
                            
                            HStack(alignment: .top, spacing: 1){
                                Text("Date")
                                    .frame(width: 50)
                                Text("Event Name")
                                Spacer()
                                Text("Pilots")
                            }
                            .background(Color(.systemBlue).opacity(0.2))
                            Spacer()
                                .frame(height: 0.1)
                            ScrollView(.vertical){
                                ForEach(self.locationModel.locationInfo.location?.location_events ?? []){ event in
                                    HStack(alignment: .top){
                                        Button(action: {
                                            navigateToEventDetailView(event_id: event.event_id!, viewSettings: self.settings)
                                            return
                                        }) {
                                            Text(showDate(dateString: event.event_start_date!))
                                                .frame(width: 50)
                                            Text("\(event.event_name!)")
                                            Spacer()
                                            Text("\(event.total_pilots!)")
                                        }
                                    }
                                    .background(Color(.systemBlue).opacity(event.rowColor! ? 0.2 : 0 ))
                                    
                                }
                                Spacer()
                            }
                            Spacer()
                            
                        }
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }.font(.system(size: 18))
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.83 )
                        .edgesIgnoringSafeArea(.bottom)
                }
                
            }.frame(width: geometry.size.width, height: geometry.size.height * 0.9 )
            Spacer()
            ZStack{
                Spacer()
                // Inclusion of Tab View
                BottomTabView( width: geometry.size.width, height: geometry.size.height )
            }.zIndex(1)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    mutating func loadLocationDetailModel(){
        locationModel = LocationDetailViewModel(location_id: self.location_id)
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(location_id: 0)
    }
}
