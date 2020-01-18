//
//  CalbiticaResponse.swift
//  Calbitica
//
//  Created by Student on 17/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

struct CalbiticaResponse : Decodable {
    var jwt: String
    var data: [String: String]
}
