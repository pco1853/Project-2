//
//  MapViewController.swift
//  DataDownloader
//
//  Created by Jason  on 4/13/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var annotationsArray:Array<AnyObject>?
    var selectedEventCoordinates:CLLocationCoordinate2D?
    var region: MKCoordinateRegion?
    var isZoomedInView:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
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
