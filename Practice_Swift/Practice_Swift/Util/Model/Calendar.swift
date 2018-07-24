//
//  Calendar.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 24..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct Calendar : Codable {
    
    let twoWeeksYear : [ String ]?
    let twoWeeksMonth : [ String ]?
    let twoWeeksDate : [ String ]?
    let twoWeeksDay : [ String ]?
}


struct CalendarData : Codable {
    
    let status : String
    let data : Calendar?
    let message : String
}
