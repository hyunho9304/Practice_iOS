//
//  MyNaverMapViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 19..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

//  NMapViewDelegate                네이버 앱 키 등록
//  NMapPOIdataOverlayDelegate      네이버 지도 설정
//  NMapLocationManagerDelegate     네이버 현재위치 이용

class MyNaverMapViewController: UIViewController , NMapViewDelegate , NMapPOIdataOverlayDelegate , NMapLocationManagerDelegate {
    
    //여기 기본

    @IBOutlet weak var searchBtn: UIButton!
    
    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
//  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ지도설정ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    var navermapView : NMapView?    //  네이버지도
    
//  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ현재위치 , 헤더ㅡㅡㅡㅡㅡㅡ
    //  현재위치 눌렀는지 state 표시
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    var currentLocationBtn : UIButton?  //  현재위치 버튼
    var currentState: state = .disabled //  현재 state 값 설정

//  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ마커ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    @IBOutlet var calloutView: UIView!  //  마커뷰
    var calloutIndex : String?  //  callout index 번호 저장해서 다음뷰에 넘길때 알수있도록 한다.
    @IBOutlet weak var calloutImageView: UIImageView!   //  마커 이미지
    @IBOutlet weak var calloutTitleLabel: UILabel!  //  마커 제목
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        //  네이버지도 생성
        navermapView = NMapView(frame: self.view.frame )
    
        if let mapView = navermapView {
            
            //  delegate 설정
            mapView.delegate = self
            
            //  네이버 앱 키 설정
            mapView.setClientId("HbFlzqmFQgRg0VxTzc63")
            
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(mapView)
        }
        
        // 현재위치 표시 버튼 생성
        currentLocationBtn = createButton()
        
        if let button = currentLocationBtn {
            view.addSubview(button)
        }
        
        setting()

    }
    
    func setting() {
        
        view.addSubview(searchBtn)
        searchBtn.addTarget(self, action: #selector(self.pressedSearchBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedSearchBtn( _ sender : UIButton ) {
        
        guard let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        
        searchVC.tempText = "검색검색"
        
        self.present( searchVC , animated: false , completion: nil )
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if view.frame.size.width != size.width {
            if let mapView = navermapView, mapView.isAutoRotateEnabled {
                mapView.setAutoRotateEnabled(false, animate: false)
                
                coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                    if let mapView = self.navermapView {
                        mapView.setAutoRotateEnabled(true, animate: false)
                    }
                }, completion: nil)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        navermapView?.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navermapView?.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navermapView?.viewDidDisappear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navermapView?.viewDidAppear()
        
        showMarkers()   //  maker 보이게 설정
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navermapView?.viewWillDisappear()
        
        stopLocationUpdating()  //  현재위치 err 시
    }
    
    
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    
    func onMapViewIsGPSTracking(_ mapView: NMapView!) -> Bool {
        return NMapLocationManager.getSharedInstance().isTrackingEnabled()
    }
    
    func findCurrentLocation() {
        enableLocationUpdate()
    }
    
    func setCompassHeadingValue(_ headingValue: Double) {
        
        if let mapView = navermapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    // MARK: - My Location
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        navermapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                navermapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        navermapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    // MARK: - Button Control
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 15, y: 30, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
        }
    }
    
    // MARK : Marker
    
    func showMarkers() {
        
        if let mapOverlayManager = navermapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(7)
                
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.922584, latitude: 37.554499), title: "버스킹존 1", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.922639, latitude: 37.554532), title: "버스킹존 2", type: UserPOIflagTypeDefault, iconIndex: 1, with: nil)
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.922696, latitude: 37.554559), title: "버스킹존 3", type: UserPOIflagTypeDefault, iconIndex: 2, with: nil)
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.922759, latitude: 37.554605), title: "버스킹존 4", type: UserPOIflagTypeDefault, iconIndex: 3, with: nil)
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.922829, latitude: 37.554659), title: "버스킹존 5", type: UserPOIflagTypeDefault, iconIndex: 4, with: nil)
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.924679, latitude: 37.556004), title: "광장무대", type: UserPOIflagTypeDefault, iconIndex: 5, with: nil)
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.925701, latitude: 37.556344), title: "여행무대", type: UserPOIflagTypeDefault, iconIndex: 6, with: nil)
                
                poiDataOverlay.endPOIdata()
                
                // show all POI data
                poiDataOverlay.showAllPOIdata()
                
                //  디폴트로 선택누르고 있는거
                //poiDataOverlay.selectPOIitem(at: 2, moveToCenter: false, focusedBySelectItem: true)
                
            }
        }
    }
    
    func clearOverlays() {
        if let mapOverlayManager = navermapView?.mapOverlayManager {
            mapOverlayManager.clearOverlays()
        }
    }
  
    
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡdelegateㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    
//  NMapViewDelegate Methods
    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        
        if (error == nil) { // success
            //  지도의 디폴드 위치 , 레벨 단계 **레벨단계 test 해야함
            mapView.setMapCenter(NGeoPoint(longitude:126.924017, latitude:37.555752), atLevel:12)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // 모드설정 : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }

//  NMapPOIdataOverlayDelegate Methods
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        
        return CGPoint(x: 0.5, y: 0.0)
    }
    

//    //  마커 선택시 나타나는 뷰 설정
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {

        //  뷰 설정
        calloutIndex = String(poiItem.iconIndex)        //  index 설정해서 다음뷰에 넘길때 알려준다
        calloutTitleLabel.text = poiItem.title
        calloutImageView.image = #imageLiteral(resourceName: "uploadImage.png")

        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1

        return calloutView
    }
    
    // 마커 선택??????????????????????
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, didSelectCalloutOfPOIitemAt index: Int32, with object: Any!) -> Bool {
        
//        let buskingDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuskingDetailViewController") as? BuskingDetailViewController
//
//        buskingDetailVC?.tempText = String(index)
//
//        self.present( buskingDetailVC! , animated: true , completion: nil )
//
        return true
    }
    

//  NMapLocationManagerDelegate Methods
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        //  현재 위치 변경 시 호출된다. location객체에 변경된 위치 정보가 전달된다.
        let coordinate = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        navermapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        navermapView?.setMapCenter(myLocation)
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        //  현재 위치 탐색 실패 시 호출된다. 실패 원인은 errorType으로 전달된다.
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = navermapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        //  나침반 각도 변경 시 호출된다. heading 객체에 각도 정보가 전달된다.
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
}
