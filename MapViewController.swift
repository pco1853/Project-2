//
//  MapViewController.swift
//  DataDownloader
//
//  Created by Jason  on 4/13/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    var annotationsArray:Array<AnyObject>?
    var selectedEventCoordinates:CLLocationCoordinate2D?
    var region: MKCoordinateRegion?
    var isZoomedInView:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        getAnnotations()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if(isZoomedInView)
        {
            mapView.setRegion(region!, animated: true)
        }
        else
        {
            isZoomedInView = false
        }
        
        getAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //updating our current location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

    }
    
    //Helper function to determine which annotations to display on the mapview
    func getAnnotations()
    {
        for m in musicEvents
        {
            var testLocation = m.getCoordinates()
            
            //The web service does not have location info about all concert events....
            //If the coordinate of an event isn't given by the web service then we don't want to display it on the map
            if !(testLocation.latitude == 0.0 && testLocation.longitude == 0.0)
            {
                self.mapView.addAnnotation(m)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Green
        }
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
        
    }
    

    //view

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
