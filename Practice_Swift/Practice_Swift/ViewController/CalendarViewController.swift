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
    
    @IBOutlet weak var selectDateTime: UILabel!
    
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
                
                //  중요 => 여러가지 int to string 방법,, 한가지 변환하는것도 중요에 있음
//                if let tmpYear = self.calendar?.twoWeeksYear![0], let tmpMonth = self.calendar?.twoWeeksMonth![0] , let tmpDate = self.calendar?.twoWeeksDate![0]   {
//
//                    year = String( tmpYear )
//                    month = String( tmpMonth )
//                    date = String( tmpDate )
//                    day = (self.calendar?.twoWeeksDay![0])!
//
//                }
                
                let year = self.calendar?.twoWeeksYear![0]
                let month = self.calendar?.twoWeeksMonth![0]
                let date = self.calendar?.twoWeeksDate![0]
                let day = self.calendar?.twoWeeksDay![0]

                var tmpDateTime = ""
                tmpDateTime.append( year!)
                tmpDateTime.append( "년 " )
                tmpDateTime.append( month! )
                tmpDateTime.append( "월 " )
                tmpDateTime.append( date! )
                tmpDateTime.append( "일 " )
                tmpDateTime.append( day! )
                
                self.selectDateTime.text = tmpDateTime
                
                //self.selectDateTime.text = year + "년 " + month + "월 " + date + "일 " + day
                
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
        cell.calendarDateLabel.text = calendar?.twoWeeksDate![ indexPath.row ]
        
        //  중요 => int로 받았을 때 string 변환 안되서 text 할수없을 때 변환방법
//        if let tmpData = calendar?.twoWeeksDate![ indexPath.row ] {
//            cell.calendarDateLabel.text = String( tmpData )
//        }
        
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
