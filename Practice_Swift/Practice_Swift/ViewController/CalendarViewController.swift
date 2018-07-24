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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()

    }
    
    func setting() {
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }
    
    
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    //  cell 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
    }

   

}
