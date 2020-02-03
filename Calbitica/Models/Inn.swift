//
//  Inn.swift
//  Calbitica
//
//  Created by user on 3/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

//{
//    "data": {
//        "sleep": true,
//        "message": "You're resting in the Inn. Damage is paused."
//    }
//}

import Foundation

struct InnResponse: Codable {
    var data: InnInfo
    var jwt: String?
}

struct InnInfo: Codable {
    var sleep: Bool
    var message: String
}
