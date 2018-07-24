//
//  Extension.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 24..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func gsno(_ value: String?) -> String {
        return value ?? ""
    }
    
    func gino(_ value: Int?) -> Int {
        return value ?? 0
    }
    
}

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}





