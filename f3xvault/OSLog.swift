//
//  OSLog.swift
//  f3xvault
//
//  Created by Timothy Traver on 6/4/20.
//  Copyright © 2020 Timothy Traver. All rights reserved.
//

import os

private let subsystem = "com.f3xvault"

struct Log {
  static let debug = OSLog(subsystem: subsystem, category: "debug")
}

func debugLog(_ message: StaticString, _ variable: String = ""){
    if variable != "" {
        os_log(message, log: Log.debug, variable)
    }else{
        os_log(message, log: Log.debug)
    }
}
