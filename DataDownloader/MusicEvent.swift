//
//  MusicEvent.swift
//  DataDownloader
//
//  Created by Student on 4/6/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import Foundation
import CoreLocation

class MusicEvent:NSObject
{
    //all info about a particular music event (more things can be added depending on what data we wanna pull from the web service)
    private var title:String
    private var latitude:Float
    private var longitude:Float
    private var city:String
    private var coordinates:CLLocationCoordinate2D
    
    //initialize every event with at least a title, city, and coordinate location
    init(title:String, latitude:Float, longitude:Float, city:String)
    {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
    }
    
    func getTitle()->String
    {
       return self.title
    }
    
    func getCity()->String
    {
        return self.city
    }
    
    func getCoordinates()->CLLocationCoordinate2D
    {
        return self.coordinates
    }
}