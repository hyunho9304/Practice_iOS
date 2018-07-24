//
//  Server.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 24..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct Server : APIService {
    
    static func reqCalendar( completion : @escaping ( Calendar , _ status : Int ) -> Void ) {
        
        let URL = url( "/calendar/date")
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let calendarData = try decoder.decode(CalendarData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( calendarData.data! , 200 )
                        }
                        else{
                            
                            completion( calendarData.data! , 500 )
                        }
                        
                    } catch {
                        print("제바아아아알")
                    }
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
}
