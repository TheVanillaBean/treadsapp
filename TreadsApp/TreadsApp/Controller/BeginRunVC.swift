//
//  BeginRunVC.swift
//  TreadsApp
//
//  Created by Alex on 1/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import MapKit

class BeginRunVC: LocationVC {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastRunCloseBtn: UIButton!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var lastRunBGView: UIView!
    @IBOutlet weak var lastRunStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationAuthStatus()
        mapView.delegate = self
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getlastRun()
    }
    
    
    @IBAction func lastRunCloseBtnPressed(_ sender: Any) {
        lastRunStackView.isHidden = true
        lastRunBGView.isHidden = true
        lastRunCloseBtn.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    
    func getlastRun() {
        guard let lastRun = Run.getAllRuns()?.first else {
            lastRunStackView.isHidden = true
            lastRunBGView.isHidden = true
            lastRunCloseBtn.isHidden = true
            return
        }
        
        lastRunStackView.isHidden = false
        lastRunBGView.isHidden = false
        lastRunCloseBtn.isHidden = false
        
        paceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.metersToMiles(to: 2)) mi"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
    }
    
    @IBAction func locationCenterBtnPressed(_ sender: Any) {
        
    }
    
}

extension BeginRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}

