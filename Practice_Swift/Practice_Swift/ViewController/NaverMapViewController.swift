//
//  NaverMapViewController.swift
//  Practice_Swift
//
//  Created by 박현호 on 2018. 7. 17..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class NaverMapViewController: UIViewController , NMapViewDelegate , NMapPOIdataOverlayDelegate {

    var mapView: NMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NMapView(frame: self.view.frame)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
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
    }
    
    public func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            mapView.setMapCenter(NGeoPoint(longitude:126.936888, latitude:37.563657), atLevel:11)
            
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
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


}
