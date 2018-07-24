//
//  HiddenAlert2ViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 8..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class HiddenAlert2ViewController: UIViewController {
    
    @IBOutlet weak var alertBtn: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertBackBtn: UIButton!
    
    var alertUp : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTarget()
    }
    
    func settingTarget() {
        
        alertUp = false
        
        alertBtn.addTarget(self, action: #selector(self.pressedAlertBtn(_:)), for: UIControlEvents.touchUpInside)
        alertBackBtn.addTarget(self, action: #selector(self.pressedAlertBackBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedAlertBtn( _ sender : UIButton ) {
        
        
        if alertUp == false {

            alertView.frame.origin.y -= alertView.frame.size.height
            alertView.layoutIfNeeded()
            alertUp = true
        }
    }
    
    @objc func pressedAlertBackBtn( _ sender : UIButton ) {
        
        if alertUp == true {

            alertView.frame.origin.y += alertView.frame.size.height
            alertView.layoutIfNeeded()
            alertUp = false
        }
    }


}
