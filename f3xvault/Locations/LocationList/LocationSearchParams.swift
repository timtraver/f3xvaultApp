//
//  SwiftUIView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct LocationSearchParamsView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    //var pilot_id: Int = 0
    //@ObservedObject var viewModel = PilotViewModel(pilot_id: 0)
    
    @State private var selectedCountry = ""
    @State private var selectedType = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    let countries = getCountries()
    let event_types : [(key: String, value: String)] = [
        "" : "All",
        "f3f" : NSLocalizedString("F3F Slope Racing", comment: "F3F Slope Racing"),
        "f3b" : NSLocalizedString("F3B Multi Task", comment: "F3B Multi Task"),
        "f3j" : NSLocalizedString("F3J Thermal Duration", comment: "F3J Thermal Duration"),
        "f5j" : NSLocalizedString("F5J Electric Duration", comment: "F5J Electric Duration"),
        "f3k" : NSLocalizedString("F3K Hand Launch", comment: "F3K Hand Launch"),
        "td"  : NSLocalizedString("Thermal Duration", comment: "Thermal Duration"),
        "mom" : NSLocalizedString("MOM Slope Racing", comment: "MOM Slope Racing"),
        "gps" : NSLocalizedString("GPS Triangle Racing", comment: "GPS Triangle Racing"),
        ].sorted{$0.key < $1.key}

    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack(alignment: .top) {
                        Text("Locations Search")
                            .font(.title)
                            .fontWeight(.semibold)
                        VStack{
                            HStack{
                                Spacer()
                            }
                            HStack {
                                Spacer()
                            }
                            Spacer()
                        }.frame(height: 20)
                            .padding(.trailing, 5)
                    }
                    .padding(.leading, 5)
                }.frame(height: 30)
                
                // Main VStack Content Frame
                VStack{
                    VStack() {
                        HStack {
                            Text("Search Parameters")
                                .padding(.leading, 5.0)
                                .frame( height: 24.0, alignment: .leading )
                                .foregroundColor(.white)
                            Spacer()
                        }.padding(.top, 2)
                            .background(Color(.systemBlue))
                    }
                    Spacer().frame(height: 0.01)
                    //ScrollView{
                    // Start Main Content Here
                    // Either Using the scroll view or the vstack for control
                    // // // // // // // // // // // // // // // // //
                    VStack{
                        NavigationView {
                            Form {
                                Section(header: Text("By Type")){
                                    Picker(selection: self.$selectedType, label: Text("Discipline Type")) {
                                        ForEach( self.event_types, id: \.key) { type in
                                            Text(type.value)
                                        }
                                    }
                                }
                                Section(header: Text("By Country")){
                                    Picker(selection: self.$selectedCountry, label: Text("Country Code")) {
                                        ForEach( self.countries, id: \.code) { country in
                                            Text(country.name)
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                        
                        Button(action: {
                            // Action Here
                            // Set the environment variables to what they selected
                            self.settings.search.country = ""
                            self.settings.search.event_type_code = ""
                            self.settings.search.per_page = 1000
                            // Now go back to the search screen
                            navigateToView(viewName: "LocationList", viewSettings: self.settings)
                            return
                        }                            ) {
                            HStack{
                                Spacer()
                                    .frame(width: 20.0)
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 30))
                                    .frame(width: 30)
                                Spacer()
                                    .frame(width: 20.0)
                                Text("Clear Search Filters")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.white))
                                    .frame(width: 200)
                                Spacer()
                            }
                            .frame(width: 300.0, height: 50.0)
                            .background(Color(.systemOrange))
                            .cornerRadius(10)
                        }
                        .foregroundColor(Color(.white))
                        .padding(.horizontal, 20)
                        Spacer()
                        
                        
                        Button(action: {
                            // Action Here
                            print(self.selectedType)
                            print(self.selectedCountry)
                            // Set the environment variables to what they selected
                            self.settings.search.country = self.selectedCountry
                            self.settings.search.event_type_code = self.selectedType
                            // Now go back to the search screen
                            navigateToView(viewName: "LocationList", viewSettings: self.settings)
                            return
                        }                            ) {
                            HStack{
                                Spacer()
                                    .frame(width: 20.0)
                                Image(systemName: "line.horizontal.3.decrease.circle")
                                    .font(.system(size: 30))
                                    .frame(width: 30)
                                Spacer()
                                    .frame(width: 20.0)
                                Text("Apply Search Filters")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.white))
                                    .frame(width: 200)
                                Spacer()
                            }
                            .frame(width: 300.0, height: 50.0)
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                        }
                        .foregroundColor(Color(.white))
                        .padding(.horizontal, 20)
                        Spacer()
                        
                        
                    }.onAppear(){
                        self.loadSettings()
                    }
                    
                    
                    
                    // End of Main Content Here
                    // Don't touch anything below here unless necessary
                    // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    //}
                    //.frame(width: geometry.size.width, height: geometry.size.height * 0.83 )
                    //.edgesIgnoringSafeArea(.bottom)
                }
            }.frame(width: geometry.size.width, height: geometry.size.height * 0.8 )
            ZStack{
                // Inclusion of Tab View
                Spacer()
                BottomTabView( width: geometry.size.width, height: geometry.size.height )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Uncomment this to load the initial model if it has parameters for the view
    func loadSettings(){
        print(self.settings.search.country!)
        print(self.settings.search.event_type_code!)
        
        self.selectedCountry = self.settings.search.country ?? ""
        self.selectedType = self.settings.search.event_type_code ?? ""
    }
}

struct LocationSearchParamsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchParamsView().environmentObject(VaultSettings())
    }
}
