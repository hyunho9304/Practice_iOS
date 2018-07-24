//
//  APIservice.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 24..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

protocol APIService {
    
}

extension APIService {
    
    static func url( _ path : String ) -> String {
        
        return "http://13.124.195.255:3001" + path
    }
}
