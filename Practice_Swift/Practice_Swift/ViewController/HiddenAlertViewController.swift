//
//  HiddenAlertViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 7..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class HiddenAlertViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var alertBtn: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertBackBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTarget()
    }
    
    func settingTarget() {
        
        alertBtn.addTarget(self, action: #selector(self.pressedAlertBtn(_:)), for: UIControlEvents.touchUpInside)
        alertBackBtn.addTarget(self, action: #selector(self.pressedAlertBackBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedAlertBtn( _ sender : UIButton ) {
        
        alertView.isHidden = false
        
        
    }
    
    
    
    
    @objc func pressedAlertBackBtn( _ sender : UIButton ) {
        
        alertView.isHidden = true
    }

}
