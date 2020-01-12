//
//  CommandList.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/11/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import Foundation

struct Command:Codable {
    var name:String
    var flag: String
    var number: Int
    var monitor_id: String?
}

struct CommandList:Codable {
    var input_source:[Command]?
    var monitor_power:[Command]?
    var speaker_power:[Command]?
    var speaker_volume:[Command]?
}

struct CommandResponse:Codable {
    var code:Int
    var message:String?
}
