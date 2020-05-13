//
//  PlaneDetailView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/8/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI

struct PlaneDetailView: View {
    var plane_id: Int = 0
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    @ObservedObject var planeDetail = PlaneDetailViewModel(plane_id: 0)
    
    init(plane_id: Int){
        self.plane_id = plane_id
        self.loadPlaneDetailModel()
    }
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                // Page Title
                VStack{
                    HStack {
                        Text("Plane Detail")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "PlaneList", viewSettings: self.settings)
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
                        VStack(alignment: .center) {
                            Group{
                                HStack {
                                    Text("Plane Detail")
                                        .padding(.leading, 5.0)
                                        .frame( height: 24.0, alignment: .leading )
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(.top, 2)
                                    .background(Color(.systemBlue))
                                
                                HStack {
                                    Text("Name")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text("\(self.planeDetail.planeDetail.plane?.plane_name ?? "")")
                                    Spacer()
                                }.padding(1.0)
                                HStack {
                                    Text("Country")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( "\(self.planeDetail.planeDetail.plane?.country_code ?? "") - " + getFlag(from: self.planeDetail.planeDetail.plane?.country_code ?? "") )
                                    Spacer()
                                }.padding(1.0)
                                HStack {
                                    Text("Manufacturer")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( "\(self.planeDetail.planeDetail.plane?.plane_manufacturer ?? "")" )
                                    Spacer()
                                }.padding(1.0)
                                HStack {
                                    Text("Year")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125.0, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( String(self.planeDetail.planeDetail.plane?.plane_year ?? 0) )
                                    Spacer()
                                }.padding(1.0)
                                HStack {
                                    Text("Website")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Button(action: {
                                        UIApplication.shared.open(URL(string: self.planeDetail.planeDetail.plane?.plane_website ?? "")!)
                                    }) {
                                        Text( "\(self.planeDetail.planeDetail.plane?.plane_website ?? "")" )
                                            .font(.system(size: 12))
                                    }
                                    Spacer()
                                }.padding(1.0)
                                HStack(alignment: .top) {
                                    Text("Flying Types")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    VStack(alignment: .leading){
                                        ForEach(self.planeDetail.planeDetail.plane?.disciplines ?? []){ disc in
                                            Text("\(disc.discipline_description ?? "")")
                                                .font(.system(size: 12))
                                        }
                                    }
                                    Spacer()
                                }.padding(1.0)
                                
                            }
                            Group{
                                HStack {
                                    Text("Plane Specs")
                                        .padding(.leading, 5.0)
                                        .frame( height: 24.0, alignment: .leading )
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(.top, 2)
                                    .background(Color(.systemBlue))
                                
                                HStack {
                                    Text("Wingspan")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( "\(self.planeDetail.planeDetail.plane?.plane_wingspan ?? 0) " + "\(self.planeDetail.planeDetail.plane?.plane_wingspan_units ?? "")" )
                                    Spacer()
                                }.padding(1.0)
                                
                                HStack {
                                    Text("Length")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( "\(self.planeDetail.planeDetail.plane?.plane_length ?? 0) " + "\(self.planeDetail.planeDetail.plane?.plane_length_units ?? "")" )
                                    Spacer()
                                }.padding(1.0)
                                
                                HStack {
                                    Text("Wing Area")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( "\(self.planeDetail.planeDetail.plane?.plane_wing_area ?? 0) " + "\(self.planeDetail.planeDetail.plane?.plane_wing_area_units ?? "")" )
                                    Spacer()
                                }.padding(1.0)
                                HStack {
                                    Text("Tail Area")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( "\(self.planeDetail.planeDetail.plane?.plane_tail_area ?? 0) " + "\(self.planeDetail.planeDetail.plane?.plane_wing_area_units ?? "")" )
                                    Spacer()
                                }.padding(1.0)
                                HStack {
                                    Text("Max FAI Weight")
                                        .padding(.leading, 5.0)
                                        .frame(width: 125, height: 24.0, alignment: .leading )
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                    Text( "\(self.planeDetail.planeDetail.plane?.plane_max_g ?? 0) g  or " + "\(self.planeDetail.planeDetail.plane?.plane_max_oz ?? 0) oz" )
                                        .foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                }.padding(1.0)
                            }
                            Group{
                                // Group for pilots that use this plane
                                HStack {
                                    Text("Pilots That Use This Plane")
                                        .padding(.leading, 5.0)
                                        .frame( height: 24.0, alignment: .leading )
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(1.0)
                                    .background(Color(.systemBlue))
                                
                                HStack(alignment: .top, spacing: 1){
                                    Text("")
                                        .frame(width: 30)
                                    Text("Pilot Name")
                                    Spacer()
                                }
                                .background(Color(.systemBlue).opacity(0.2))
                                Spacer()
                                    .frame(height: 0.1)
                                ScrollView(.vertical){
                                    ForEach(self.planeDetail.planeDetail.plane?.plane_pilots ?? []){ pilot in
                                        HStack(alignment: .top){
                                            Text(getFlag(from: pilot.country_code ?? ""))
                                                .frame(width: 30)
                                            Button(action: {
                                                // action
                                                navigateToPilotDetailView(pilot_id: pilot.pilot_id!, viewSettings: self.settings)
                                                return
                                            }) {
                                                Text("\(pilot.pilot_first_name!) \(pilot.pilot_last_name!) ")
                                                Spacer()
                                            }
                                        }
                                        .background(Color(.systemBlue).opacity(pilot.rowColor! ? 0.2 : 0 ))
                                        
                                    }
                                    Spacer()
                                }
                                .font(.system(size: 20))
                                Spacer()
                            }
                            
                            
                        }.font(.system(size: 16))
                        
                        
                        
                        
                        
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.85 )
                    .edgesIgnoringSafeArea(.bottom)
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.88 )
                // Inclusion of Tab View
                
                BottomTabView( width: geometry.size.width, height: geometry.size.height )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Uncomment this to load the initial model if it has parameters for the view
    mutating func loadPlaneDetailModel(){
        planeDetail = PlaneDetailViewModel(plane_id: self.plane_id)
    }
}

struct PlaneDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaneDetailView(plane_id: 0).environmentObject(VaultSettings())
    }
}
