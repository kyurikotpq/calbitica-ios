//
//  Responses.swift
//  Calbitica
//
//  Created by Student on 7/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

// For handling Calendar requests
struct CalendarsResponse : Codable {
    var jwt: String?
    var data: [CalbiticaCalendar]
}

// For handling Calbit requests
struct CalbitsResponse : Codable {
    var jwt: String?
    var data: [Calbit?]
}

// For handling Profile requests
struct ProfileResponse: Codable {
    var data: Profile
    var jwt: String?
}

// For handling Quest responses
struct QuestResponse: Codable {
    var data: QuestInfo
    var jwt: String?
}

// For handling Inn resopnses
struct InnResponse: Codable {
    var data: InnInfo
    var jwt: String?
}
