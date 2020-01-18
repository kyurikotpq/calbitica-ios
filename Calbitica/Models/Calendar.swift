//
//  Calendar.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

struct Calendar : Codable {
    struct CalbiticaData : Codable {
        var _id: String // MongoDB ID
        var userID: String // MongoDB ID
        var googleID: String
        var summary: String
        var description: String?
        var sync: Bool
        
        struct Reminder : Codable {
            var method: String
            var minutes: Int
        }
        var reminders: [Reminder]

    }
    var data: CalbiticaData
}

