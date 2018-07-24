//
//  CalendarViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 24..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    var calendar : Calendar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        dateTimeInit()
    }
    
    func setting() {
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }
    
    func dateTimeInit() {
        
        Server.reqCalendar { (calendarData , rescode) in
            
            if rescode == 200 {
                
                self.calendar = calendarData
                self.calendarCollectionView.reloadData()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 14   //  2주표현
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath ) as! CalendarCollectionViewCell
        
        cell.calendarDayLabel.text = calendar?.twoWeeksDay![ indexPath.row ]
        
        if let tmpData = calendar?.twoWeeksDate![ indexPath.row ] {
            cell.calendarDateLabel.text = String( tmpData )
        }
        
        return cell
    
    }
    
//    //  cell 선택했을 때
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//
//    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 55 * self.view.frame.width/375 , height: 68 * self.view.frame.height/667 )
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

}
