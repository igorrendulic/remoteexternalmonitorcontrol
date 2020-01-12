//
//  Ping.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/11/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import Foundation

struct Ping:Decodable {
    let pong:String?
    let ip:String?
}
