//
//  HomeViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var naverMapBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    
    func setting() {
        
        naverMapBtn.addTarget(self, action: #selector(self.pressedNaverMapBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedNaverMapBtn( _ sender : UIButton ) {
        
        guard let naverMapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyNaverMapViewController") as? MyNaverMapViewController else { return }
        
        self.present( naverMapVC , animated: true , completion: nil )
    }
}
