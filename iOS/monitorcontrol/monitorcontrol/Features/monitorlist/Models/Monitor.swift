//
//  Monitor.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/11/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import Foundation

public struct Monitor : Codable {
    let id: String
    let name: String
    let screen: String?
    let serial: String?
}
