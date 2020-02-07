//
//  Quest.swift
//  Calbitica
//
//  Created by user on 3/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

//{
//    "data": {
//        "progress": {
//            "collect": {}
//        },
//        "active": false,
//        "key": "atom1",
//        "leader": "cd28741a-e7dd-49c2-9187-8832532f2e9f",
//        "members": {
//            "cd28741a-e7dd-49c2-9187-8832532f2e9f": true,
//            "10213571-a212-4ca9-816a-0d05c79a04eb": null,
//            "374a05d6-091d-401d-b9ef-8b5e3c71c8c5": true,
//            "5b962f5d-09bb-482a-8d06-1e954ecc924e": null
//        },
//        "extra": {}
//    }
//}

import Foundation

struct QuestInfo: Codable {
    var progress: [String: String?]
    var active: Bool
    var key: String?
    var leader: String
    var members: [String: Bool?]
    var extra: [String?]
}


