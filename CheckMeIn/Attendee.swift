//
//  Attendee.swift
//  CheckMeIn
//
//  Created by Mitchell Sweet on 6/7/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import Foundation

struct Attendee: Codable {
    let firstName: String
    let lastName: String
    let description: String
    let date: Date
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
