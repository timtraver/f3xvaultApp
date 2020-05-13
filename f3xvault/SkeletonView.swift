//
//  SwiftUIView.swift
//  f3xvault
//
//  Created by Timothy Traver on 4/7/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct SkeletonView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    // Use this section to load the Model View for this View
    // We first load it with the 0 value, then will load in the init
    //var pilot_id: Int = 0
    //@ObservedObject var viewModel = PilotViewModel(pilot_id: 0)
    
    //init(pilot_id: Int){
    //    self.pilot_id = pilot_id
    //    loadModel()
    //}

    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // Page Title
                VStack{
                    HStack(alignment: .top) {
                        Text("Skeleton")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        VStack{
                            HStack{
                                Spacer()
                                Text("Total Records : ")
                                    .font(.system(size: 10))
                                Text( " of " )
                                    .font(.system(size: 10))
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Navigation code here
                                    navigateToView(viewName: "EventSearchParams", viewSettings: self.settings)
                                    return
                                }) {
                                    Text("More Filters ")
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 10))
                                        .padding(.trailing, 5)
                                }
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
                            Text("Pilot Planes")
                                .padding(.leading, 5.0)
                                .frame( height: 24.0, alignment: .leading )
                                .foregroundColor(.white)
                            Spacer()
                        }.padding(.top, 2)
                            .background(Color(.systemBlue))
                    }
                    Spacer().frame(height: 0.01)
                    ScrollView{
                        // Start Main Content Here
                        // Either Using the scroll view or the vstack for control
                        // // // // // // // // // // // // // // // // //
                        
                        
                        
                        
                        //Main Content of view
                        VStack{
                            Group{
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                            }
                            Group{
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                            }
                            Group{
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                            }
                            Group{
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                            }
                            Group{
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                            }
                            Group{
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                                Text("Stuff")
                            }
                        }
                        
                        
                        
                        // End of Main Content Here
                        // Don't touch anything below here unless necessary
                        // \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.83 )
                    .edgesIgnoringSafeArea(.bottom)
                }

            }.frame(width: geometry.size.width, height: geometry.size.height * 0.9 )
            Spacer()
            ZStack{
                // Inclusion of Tab View
                Spacer()
                BottomTabView( width: geometry.size.width, height: geometry.size.height )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Uncomment this to load the initial model if it has parameters for the view
    //mutating func loadModel(){
    //    viewModel = PilotViewModel(pilot_id: self.pilot_id)
    //}
}

struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonView().environmentObject(VaultSettings())
    }
}
