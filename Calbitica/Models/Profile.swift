//
//  Profile.swift
//  Calbitica
//
//  Created by user on 2/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

//{
//    "data": {
//        "profile": {
//            "name": "Calbitica Test User"
//        },
//        "stats": {
//            "lvl": 15,
//            "class": "Rogue",
//            "hp": 40,
//            "exp": 317,
//            "mp": 49,
//            "gp": 483,
//            "maxHealth": 50,
//            "toNextLevel": 350,
//            "maxMP": 52
//        },
//        "preferences": {
//            "hair": {
//                "color": "red",
//                "base": 3,
//                "bangs": 1,
//                "beard": 0,
//                "mustache": 0,
//                "flower": 1
//            },
//            "tasks": {
//                "groupByChallenge": false,
//                "confirmScoreNotes": false
//            },
//            "size": "slim",
//            "skin": "915533",
//            "shirt": "blue",
//            "chair": "none",
//            "sleep": true,
//            "disableClasses": false,
//            "background": "purple"
//        },
//        "party": {
//            "quest": {
//                "progress": {
//                    "up": 82.47907323419412,
//                    "down": 0,
//                    "collectedItems": 24
//                },
//                "RSVPNeeded": false,
//                "key": null,
//                "completed": null
//            },
//            "order": "level",
//            "orderAscending": "ascending",
//            "_id": "9ca76996-3bc3-435a-9bcd-d417791fed3f"
//        }
//    }
//}

import Foundation

struct Profile : Codable {
    var profile: [String: String]
    
    struct Stats: Codable {
        var lvl: Float
        var `class`: String
        var hp: Float
        var exp: Float
        var mp: Float
        var gp: Float
        var maxHealth: Float
        var toNextLevel: Float
        var maxMP: Float
    }
    
    var stats: Stats
    
    var preferences: Preferences
    var party: Party
}

struct Preferences: Codable {
    struct Hair: Codable {
        var `color`: String
        var base: Float
        var bangs: Float
        var beard: Float
        var mustache: Float
        var flower: Float
    }
    
    var hair: Hair
    var tasks: [String: Bool]
    var size: String
    var skin: String
    var shirt: String
    var chair: String
    var sleep: Bool
    var disableClasses: Bool
    var background: String
}

struct Party: Codable {
    var quest: Quest
    var order: String
    var orderAscending: String
    var `_id`: String
}

struct Quest: Codable {
    var progress: [String: Float]
    var RSVPNeeded: Bool
    var key: String?
    var completed: Bool?
}
