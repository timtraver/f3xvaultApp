//
//  ContentView.swift
//  f3xvault
//
//  Created by Timothy Traver on 3/27/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import SwiftUI
import UIKit

struct LoginView: View {
    
    @EnvironmentObject var settings: VaultSettings
    
    @State public var login = ""
    @State public var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State var networkIndicator = false
    
    // Get the current year
    let year = String( Calendar.current.component(.year, from: Date()))
    // let get values from the keychain
    let keychain = KeychainSwift()
    
    var body: some View {
        ZStack{
            // Background color
            Color(.systemBlue)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Logo
                Image("medF3Xlogo")
                    .resizable()
                    .frame(width: 150, height: 150)
                
                // Title Text
                Text("F3XVault")
                    .font(.system(size: 60))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                
                
                VStack(alignment: .center) {
                    
                    TextField("Email Address or Login", text: $login)
                        .foregroundColor(Color.black)
                        .padding(10)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 0, maxWidth: 300)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(Color.black)
                        .padding(10)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 0, maxWidth: 300)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Button(action: {
                        self.loginToSystem()
                        return
                    }
                    ) {
                        HStack{
                            Spacer()
                                .frame(width: 48)
                            Text("Login")
                                .font(.system(size: 26))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                                .frame(width: 24)
                            
                            if networkIndicator {
                                ActivityIndicator(style: .medium)
                            }else{
                                Spacer()
                                    .frame(width: 20)
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                    )
                    
                    Spacer()
                        .frame(height: 15)
                    
                    Text("Or")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                        .frame(height: 15)
                    
                    Button(action: {
                        // Basically Navigate to the home view without a login
                        // Make the settings have those zeroed out values too
                        self.settings.keep_logged_in = false
                        self.settings.user_id = 0
                        self.settings.user_name = ""
                        self.settings.user_first_name = "Guest"
                        self.settings.user_last_name = ""
                        self.settings.pilot_id = 0
                        self.settings.pilot_ama = ""
                        self.settings.pilot_fai = ""
                        self.settings.pilot_fai_license = ""
                        self.settings.pilot_city = ""
                        self.settings.country_code = ""
                        self.settings.state_code = ""
                        // Save these settings to the UserDefaults
                        saveSettings(settings: self.settings)
                        navigateToView(viewName: "Home", viewSettings: self.settings)
                        return
                    }
                    ) {
                        Text("Enter as Guest")
                            .font(.system(size: 26))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                    }
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                    )

                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Login Error"), message: Text( "\(alertMessage)"), dismissButton: .default(Text("Try Again")))
                }
                
                Button(action: {
                    // code for the button
                    self.settings.keep_logged_in.toggle()
                    return
                }) {
                    HStack{
                        Image(systemName: self.settings.keep_logged_in ? "checkmark.square" : "square")
                        Text("Keep me Logged In")
                    }
                    .foregroundColor(Color.white)

                }

                Spacer()
                
                // Print out the Copyright
                Text("© \(year) Tim Traver")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
            }
        }.onAppear { self.loadUser() } // Load the user from the keychain if they have logged in before
    }
    
    func loadUser(){
        // Function to load the user name and password from the keychain
        self.login = keychain.get("userLogin") ?? ""
        self.password = keychain.get("userPassword") ?? ""
        if self.settings.keep_logged_in == true {
            self.loginToSystem()
        }
    }
    
    func loginToSystem(){
        // Function to do the login, asve the data and go to the home screen
        // Check to see if they are using the same user to log in, and don't both to make the call
        if self.login == self.settings.user_name && self.settings.user_name != "" {
            // Lets save the defult settings to see if they chose to stay logged in
            saveSettings(settings: self.settings)
            // The login is the same, so lets just go home
            navigateToView(viewName: "Home", viewSettings: self.settings)
            return
        }
        // Perform the login and wait for the response to see if they can log in
        // Turn on the network indicator
        self.networkIndicator.toggle()
        // Create an instance of the API
        let call = vaultAPI()
        // Make the API call to check the user entered
        call.checkUser(login: self.login, password: self.password ) { results in
            switch results {
            case .success(let user):
                if user.response_code == 0 {
                    self.alertMessage = NSLocalizedString("Login Failed ", comment: "Login Failed") + NSLocalizedString(user.error_string, comment: "Login Error String")
                    self.password = ""
                    self.showingAlert = true
                    self.keychain.set(self.login, forKey: "userLogin")
                    self.keychain.set("", forKey: "userPassword")
                }
                if user.response_code == 1 {
                    self.alertMessage = "Login Succeeded \(user.user?.user_first_name ?? "")"
                    self.keychain.set(self.login, forKey: "userLogin")
                    self.keychain.set(self.password, forKey: "userPassword")
                    // Save the desired non critical information about the user
                    self.settings.user_id = user.user?.user_id ?? 0
                    self.settings.user_name = user.user?.user_name ?? ""
                    self.settings.user_first_name = user.user?.user_first_name ?? ""
                    self.settings.user_last_name = user.user?.user_last_name ?? ""
                    self.settings.pilot_id = user.user?.pilot_id ?? 0
                    self.settings.pilot_ama = user.user?.pilot_ama ?? ""
                    self.settings.pilot_fai = user.user?.pilot_fai ?? ""
                    self.settings.pilot_fai_license = user.user?.pilot_fai_license ?? ""
                    self.settings.pilot_city = user.user?.pilot_city ?? ""
                    self.settings.country_code = user.user?.country_code ?? ""
                    self.settings.state_code = user.user?.state_code ?? ""
                    // Save the new settings to the UserDefaults
                    saveSettings(settings: self.settings)
                    navigateToView(viewName: "Home", viewSettings: self.settings)
                }
            case .failure(let error):
                self.alertMessage = "Dude, we got an error! \(error)"
                self.showingAlert = true
            }
            self.networkIndicator.toggle()

        }
    }
    
}


struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIViewType = UIActivityIndicatorView
    
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> ActivityIndicator.UIViewType {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: ActivityIndicator.UIViewType, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
