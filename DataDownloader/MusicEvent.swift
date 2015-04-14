//
//  MusicEvent.swift
//  DataDownloader
//
//  Created by Student on 4/6/15.
//  Copyright (c) 2015 Student. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation
import MapKit

class MusicEvent:NSObject, MKAnnotation, NSCoding
{
    //all info about a particular music event (more things can be added depending on what data we wanna pull from the web service)
    
    var title:String?
    var subtitle:String?
    var coordinate:CLLocationCoordinate2D
    
    var eventTitle:String
    var latitude:Float
    var longitude:Float
    var city:String
    var eventName:String
    var eventAddress:String
    var eventImage:UIImage
    
    
    //initialize every event with at least a title, city, and coordinate location
    init(name:String, lat:Float, long:Float, venueCity:String, venueName:String, venueAddress:String, venueImage:UIImage)
    {
        eventTitle = name
        latitude = lat
        longitude = long
        city = venueCity
        coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        eventName = venueName
        eventAddress = venueAddress
        eventImage = venueImage
    
        title = name
        subtitle = self.city
    }
    
    required init(coder aDecoder: NSCoder)
    {
        eventTitle = aDecoder.decodeObjectForKey("eventTitle") as String
        latitude = aDecoder.decodeFloatForKey("latitude") as Float
        longitude = aDecoder.decodeFloatForKey("longitude") as Float
        coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude),CLLocationDegrees(longitude))
        city = aDecoder.decodeObjectForKey("city") as String
        eventName = aDecoder.decodeObjectForKey("eventName") as String
        eventAddress = aDecoder.decodeObjectForKey("eventAddress") as String
        eventImage = aDecoder.decodeObjectForKey("eventImage") as UIImage
        title = aDecoder.decodeObjectForKey("title") as? String
        subtitle = aDecoder.decodeObjectForKey("subtitle") as? String
        
        super.init()
    }
    
    func getTitle()->String
    {
       return eventTitle
    }
    
    func getCity()->String
    {
        return city
    }
    
    func getCoordinates()->CLLocationCoordinate2D
    {
        return coordinate
    }
    
    func getVenueName()->String
    {
        return eventName
    }
    
    func getVenueAddress()->String
    {
        return eventAddress
    }
    
    func getVenueImage()->UIImage
    {
        return eventImage
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(eventTitle, forKey: "eventTitle")
        aCoder.encodeDouble(coordinate.latitude, forKey: "latitude")
        aCoder.encodeDouble(coordinate.longitude, forKey: "longitude")
        aCoder.encodeObject(city, forKey: "city")
        aCoder.encodeObject(eventName, forKey: "eventName")
        aCoder.encodeObject(eventAddress, forKey: "eventAddress")
        aCoder.encodeObject(eventImage, forKey: "eventImage")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(subtitle, forKey: "subtitle")
        
    }
}