//
//  f3xvault_api.swift
//  f3xvault
//
//  Created by Timothy Traver on 3/31/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

class vaultAPI {
    var url: URL!
    var host: String
    var port: Int
    var uri: String
    var ssl: Bool
    var queryString: String
    var requestHeaders = [String:String]()
    var requestVariables = [String:Any]()
    var method: String
    var outputFormat: String
    var responseString: String
    var responseLines = [String]()
    var login: String
    var password: String
    
    init(){
        self.host = "www.f3xvault.com"
        self.port = 443
        self.uri = "/api.php"
        self.ssl = true
        self.queryString = ""
        self.method = "GET"
        self.responseString = ""
        self.outputFormat = "json"
        // Retrieve the user login and password from the keychain
        let keychain = KeychainSwift()
        self.login = keychain.get("userLogin") ?? ""
        self.password = keychain.get("userPassword") ?? ""
    }
    
    func setRequestVariable(name:String, value:Any){
        self.requestVariables[name] = value
    }
    
    func clearRequestVariables(){
        self.requestVariables.removeAll()
    }
    
    func buildRequestVariables() {
        self.queryString = ""
        // Add the mandatory login and password variables first
        self.setRequestVariable(name:"login", value:self.login)
        self.setRequestVariable(name:"password", value:self.password)
        self.setRequestVariable(name:"output_format", value:"json")
        
        var first = 1
        for (key, value) in requestVariables {
            if first == 1 {
                first = 0
            }else{
                self.queryString += "&"
            }
            self.queryString += "\(key)=\(value)"
        }
    }
    func prepareCall() -> URLRequest{
        self.buildRequestVariables()
        if ssl {
            url = URL(string: "https://\(host)\(uri)?\(queryString)")
        }else{
            url = URL(string: "http://\(host)\(uri)?\(queryString)")
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = self.method
        return request
    }
    
    func checkUser(login: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Set the incoming variables
        self.login = "\(login)"
        self.password = "\(password)"
        self.setRequestVariable(name: "function", value: "checkUser")
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(User.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    func getEventInfo(event_id: Int, completion: @escaping (Result<EventDetailResponse, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "getEventInfoFull")
        self.setRequestVariable(name: "event_id", value: event_id)
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(EventDetailResponse.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    func getLocationInfo(location_id: Int, completion: @escaping (Result<LocationDetailResponse, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "getLocationInfo")
        self.setRequestVariable(name: "location_id", value: location_id)
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(LocationDetailResponse.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    func getPlaneInfo(plane_id: Int, completion: @escaping (Result<PlaneDetailResponse, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "getPlaneInfo")
        self.setRequestVariable(name: "plane_id", value: plane_id)
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(PlaneDetailResponse.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    func getPilotInfo(pilot_id: Int, completion: @escaping (Result<PilotDetailResponse, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "getPilotInfo")
        self.setRequestVariable(name: "pilot_id", value: pilot_id)
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(PilotDetailResponse.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    
    func searchPilots(completion: @escaping (Result<PilotSearchList, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "searchPilots")
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(PilotSearchList.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    func searchPlanes(completion: @escaping (Result<planeSearchList, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "searchPlanes")
        self.setRequestVariable(name: "per_page", value: 1000)
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(planeSearchList.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    
    func searchLocations(discipline: String,completion: @escaping (Result<locationSearchList, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "searchLocations")
        if discipline != "" {
            self.setRequestVariable(name: "discipline", value: discipline)
        }
        self.setRequestVariable(name: "per_page", value: 1000)
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(locationSearchList.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    
    func searchEvents(completion: @escaping (Result<EventSearchList, Error>) -> Void) {
        // Set the incoming variables
        self.setRequestVariable(name: "function", value: "searchEvents")
        self.setRequestVariable(name: "per_page", value: 10000)
        let request = self.prepareCall()
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print(response?.url! ?? "")
            let results = try! JSONDecoder().decode(EventSearchList.self, from: data!)
            DispatchQueue.main.async {
                completion(.success(results))
            }
        }.resume()
        return
    }
    
}
