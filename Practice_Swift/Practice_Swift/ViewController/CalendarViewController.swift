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
    
    var selectYear : String?
    var selectMonth : String?
    var selectDate : String?
    var selectDay : String?
    
    @IBOutlet weak var selectDateTime: UILabel!
    
    var selectedIndex:IndexPath?   //  선택고려
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        dateTimeInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //auto selected 1st item
        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        
        collectionView(calendarCollectionView, didSelectItemAt: indexPathForFirstRow)
    }
    
    func setting() {
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        selectDateTime.isHidden = true
        
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
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
        
        self.selectYear = self.calendar?.twoWeeksYear![ 0 ]
        self.selectMonth = self.calendar?.twoWeeksMonth![ 0 ]
        self.selectDate = self.calendar?.twoWeeksDate![ 0 ]
        self.selectDay = self.calendar?.twoWeeksDay![ 0 ]
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

        if indexPath == selectedIndex {
            
            cell.calendarDayLabel.textColor = UIColor( red: 255, green: 0, blue: 0, alpha: 1.0 )
            cell.calendarDateLabel.textColor = UIColor( red: 255 , green: 255 , blue: 255 , alpha: 1.0 )
            cell.calendarCircleImageView.isHidden = false
            
            self.selectYear = self.calendar?.twoWeeksYear![ indexPath.row ]
            self.selectMonth = self.calendar?.twoWeeksMonth![ indexPath.row ]
            self.selectDate = self.calendar?.twoWeeksDate![ indexPath.row ]
            self.selectDay = self.calendar?.twoWeeksDay![ indexPath.row ]
            
            
            
            self.selectDateTime.text = self.selectYear! + "년 " + self.selectMonth! + "월 " + self.selectDate! + "일 " + self.selectDay!
            
            self.selectDateTime.isHidden = false
        }
        else {
            
            cell.calendarDayLabel.textColor = UIColor( red: 0, green: 0, blue: 0, alpha: 1.0 )
            cell.calendarDateLabel.textColor = UIColor( red: 0 , green: 0 , blue: 0 , alpha: 1.0 )
            cell.calendarCircleImageView.isHidden = true
        }
        
        return cell
        
    }
   
    //  중요 => cell 하이라이트
    //    //    cell 누르다가 땠을 때 안의 내용변화
    //    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    //
    //        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
    //        cell.calendarCircleImageView.isHidden = true
    //    }
    //    //    cell 누르고 있을 때 안의 내용변화
    //    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    //
    //        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
    //        cell.calendarCircleImageView.isHidden = false
    //    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedIndex = indexPath
        collectionView.reloadData()
        
        print( "선택" )
        print()
        
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
