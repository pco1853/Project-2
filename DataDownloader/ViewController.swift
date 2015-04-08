//
//  ViewController.swift
//  DataDownloader
//
//  Created by Student on 3/12/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicEvents = [MusicEvent]()
    
    let myLastFMURL = "http://ws.audioscrobbler.com/2.0/?method=artist.getevents&format=json&api_key="
    let myLastFmApiKey = "5657eb0b60719315b09d11096a3eff30"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return musicEvents.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlainCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = musicEvents[indexPath.row].getTitle()
        return cell
    }
    
    //called when we select a row in our search table view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "searchSegue"
        {
            var indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var detailVC:searchDetailVC = segue.destinationViewController as searchDetailVC
            detailVC.selectedEvent = musicEvents[indexPath.row]
        }
    }
    

    //called only when search button is clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.musicEvents.removeAll(keepCapacity: false)
        
        //get what the user searched and make it URL compatible
        var searchData = searchBar.text
        var searchString = searchData.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession.init(configuration: config)
        var endPointURL = ("\(myLastFMURL)\(myLastFmApiKey)")

        //Final URL contains what the user searched + lastFMURL + API key
        let endUrl = NSURL(string: endPointURL+"&artist="+searchString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!)
        
        let dataTask = session.dataTaskWithURL(endUrl!, completionHandler:
            {(data: NSData!, response:NSURLResponse!, error: NSError!) -> Void in
                //do something with the data
                println("response = \(response)")
                println("error = \(error)")
                var s = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                let json = JSON(data:data)
                let eventsArray = json["events"]["event"].arrayValue
                
                //looping through our data to extract what we want
                for e in eventsArray
                {
                    //getting event title
                    var eventTitle:String = e["title"].stringValue
                    if(eventTitle.isEmpty)
                    {
                        eventTitle = "No title found"
                    }
                    //getting event city
                    var eventCity:String = e["venue"]["location"]["city"].stringValue
                    if(eventCity.isEmpty)
                    {
                        eventCity = "No city found"
                    }
                    
                    //getting event latitude and longitude (Have to do annoying long cast from string to float value)
                    var eventLat:Float = NSString(string: (e["venue"]["location"]["geo:point"]["geo:lat"].stringValue)).floatValue
                    var eventLong:Float = NSString(string: (e["venue"]["location"]["geo:point"]["geo:long"].stringValue)).floatValue
                    
                    //add each event to our table
                    var event = MusicEvent(title:eventTitle, latitude: eventLat, longitude: eventLong, city: eventCity)
                    self.musicEvents.append(event)

                }
                
                //all done? call back to the main thread
                dispatch_async(dispatch_get_main_queue(),
                {
                    //seeing if our search did not result in any data. If so inform the user no results were found
                    if(self.musicEvents.count < 2)
                    {
                        self.musicEvents.removeAll(keepCapacity: false)
                        var event = MusicEvent(title: "No results found", latitude: 0.0, longitude: 0.0, city: "")
                        self.musicEvents.append(event)
                        self.tableView.reloadData()
                        
                    }
                    else
                    {
                        //update the UI
                        self.tableView.reloadData()
                    }
                })
                
            print(json)
        })
        
        dataTask.resume()
        
    }

}

