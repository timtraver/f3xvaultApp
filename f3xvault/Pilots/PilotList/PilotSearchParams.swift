//
//  PilotSearchParamsView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/19/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct PilotSearchParamsView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    @State private var selectedCountry = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    let countries = getCountries()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack(alignment: .top) {
                        Text("Pilots")
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
                            // Now go back to the search screen
                            navigateToView(viewName: "PilotList", viewSettings: self.settings)
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
                            print(self.selectedCountry)
                            // Set the environment variables to what they selected
                            self.settings.search.country = self.selectedCountry
                            // Now go back to the search screen
                            navigateToView(viewName: "PilotList", viewSettings: self.settings)
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
        self.selectedCountry = self.settings.search.country ?? ""
    }
}

struct PilotSearchParamsView_Previews: PreviewProvider {
    static var previews: some View {
        PilotSearchParamsView().environmentObject(VaultSettings())
    }
}
