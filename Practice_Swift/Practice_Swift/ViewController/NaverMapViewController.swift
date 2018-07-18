//
//  NaverMapViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 17..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class NaverMapViewController: UIViewController , NMapViewDelegate , NMapPOIdataOverlayDelegate , NMapLocationManagerDelegate {
    
    @IBOutlet weak var calloutLabel: UILabel!
    @IBOutlet weak var calloutView: UIView!
    
    
    @IBOutlet weak var naverMapView: UIView!
    var mapView: NMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NMapView(frame: naverMapView.frame)
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("HbFlzqmFQgRg0VxTzc63")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(mapView)
        }
        
        //mapView?.mapViewMode = .vector
        //mapView?.mapViewMode = .satellite
        //mapView?.mapViewMode = .hybrid
//        
//        if let lm = NMapLocationManager.getSharedInstance() {
//            // set delegate
//            lm.setDelegate(self )
//            
//            // start updating location
//            lm.startContinuousLocationInfo()
//            
//            mapView?.setAutoRotateEnabled(true, animate: true)
//            
//            // start updating heading
//            lm.startUpdatingHeading()
//        }
        
        if let mapOverlayManager = mapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(3)

                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.979, latitude: 37.567), title: "마커 1", type: UserPOIflagTypeDefault, with: nil)
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.974, latitude: 37.566), title: "마커 2", type: UserPOIflagTypeDefault, iconIndex: 2, with: nil)
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.984, latitude: 37.565), title: "마커 3", type: UserPOIflagTypeInvisible, iconIndex: 3, with: nil)
                poiDataOverlay.endPOIdata()
                
                // show all POI data
                poiDataOverlay.showAllPOIdata()
            }
        }
        
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
        calloutLabel.text = poiItem.title
        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1
        return calloutView
    }
    
    public func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            mapView.setMapCenter(NGeoPoint(longitude:126.979, latitude:37.567), atLevel:11)
            
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }

//  NMapPOIdataOverlayDelegate  DELEGATE
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
//  NMapLocationManagerDelegate DELEGATE
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        
        let coordinate = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        mapView?.setMapCenter(myLocation)
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        
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
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }


}
