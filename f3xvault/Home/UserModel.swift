//
//  f3xvault.swift
//  f3xvault
//
//  Created by Timothy Traver on 3/31/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import Foundation

// User Structures

// The user response object
struct User: Codable{
    var response_code: Int = 0
    var error_string: String = ""
    var user: UserInfo?
}

// The user sub struct
struct UserInfo: Codable{
    var user_id: Int? = 0
    var user_name: String? = ""
    var user_first_name: String? = ""
    var user_last_name: String? = ""
    var pilot_id: Int? = 0
    var pilot_first_name: String? = ""
    var pilot_last_name: String? = ""
    var pilot_ama: String? = ""
    var pilot_fai: String? = ""
    var pilot_fai_license: String? = ""
    var pilot_city: String? = ""
    var state_code: String? = ""
    var country_code: String? = ""
}
