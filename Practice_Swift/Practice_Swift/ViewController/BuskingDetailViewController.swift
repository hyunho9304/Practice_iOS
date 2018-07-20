//
//  BuskingDetailViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class BuskingDetailViewController: UIViewController {

    @IBOutlet weak var buskingIndex: UILabel!
    
    var tempText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buskingIndex.text = tempText

    }


}
