//
//  CurrentRunVC.swift
//  TreadsApp
//
//  Created by Alex on 1/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunVC: LocationVC {

    
    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    fileprivate var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var timer: Timer!
    var coordinateLocations = List<Location>()
    
    var runDistance: Double = 0.0
    var counter  = 0
    var pace: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
    }
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
    }
    
    func startTimer() {
        durationLabel.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func calculatePace(time seconds: Int, miles: Double) -> String {
        pace = Int( Double( seconds) / miles )
        return pace.formatTimeDurationToString()
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLabel.text = counter.formatTimeDurationToString()
    }
    
    @IBAction func pausedBtnPressed(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        }else {
            startRun()
        }
    }
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer){
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizerState.began || sender.state == UIGestureRecognizerState.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust){
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizerState.ended {
                
                if sliderView.center.x >= (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    endRun()
                    dismiss(animated: true, completion: nil)
                }
                
                UIView.animate(withDuration: 0.1, animations: {
                    sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
                })
            }
        }
    }

}

extension CurrentRunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        }else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            let newlocation = Location(lat: Double(lastLocation.coordinate.latitude), long: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newlocation, at: 0)
            distanceLabel.text = "\(runDistance.metersToMiles(to: 2))"
            if counter > 0 && runDistance > 0 {
                paceLabel.text = calculatePace(time: counter, miles: runDistance.metersToMiles(to: 2))
            }
        }
        
        lastLocation = locations.last
    }
}

