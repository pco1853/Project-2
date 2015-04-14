//
//  ViewController.swift
//  DataDownloader
//
//  Created by Student on 3/12/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var testArray = [MusicEvent]()
    
    let myLastFMURL = "http://ws.audioscrobbler.com/2.0/?method=artist.getevents&format=json&api_key="
    let myLastFmApiKey = "5657eb0b60719315b09d11096a3eff30"
    var emptySearchResult:Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if(musicEvents.count > 2)
        {
            emptySearchResult = false
        }
        else
        {
            emptySearchResult = true
        }
        

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
        
        //logic for the populating the subtitle
        if(musicEvents.count < 2)
        {
            cell.detailTextLabel?.text = "No additional info"
        }
        else
        {
            cell.detailTextLabel?.text = "Tap for more info"
        }
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
    
    //This checks to see if we should go to the detailed cell view
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        //we don't want the user to go to a detailed cell view if their search resulted in nothing
        if identifier == "searchSegue"
        {
            if self.emptySearchResult == true
            {
                return false
            }
            else
            {
                return true
            }
        }
        
        return true
    }

   //Will clear whatever is in the table when tapped
    @IBAction func clearTapped(sender: AnyObject)
    {
        musicEvents.removeAll(keepCapacity: false)
        self.tableView.reloadData()
    }
    
    //called only when search button is clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        //dismissed keyboard after search is pressed
        searchBar.resignFirstResponder()
        musicEvents.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        
        self.searchIndicator.center = CGPointMake(self.view.center.x, self.view.center.y)
        self.searchIndicator.hidden = false
        self.searchIndicator.startAnimating()
        
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
                    
                    //getting venue address
                    var eventAddress:String = e["venue"]["location"]["street"].stringValue
                    if(eventAddress.isEmpty)
                    {
                        eventAddress = "No address found"
                    }
                    
                    //getting venue name
                    var eventVenue:String = e["venue"]["name"].stringValue
                    if(eventVenue.isEmpty)
                    {
                        eventVenue = "No venue found"
                    }
                    
                    //getting event image
                    var images = e["image"].arrayValue
                    var mediumImage = images[2]["#text"].string!
                    var eventImage:UIImage?
                    let url = NSURL(string: mediumImage)
                    if let data = NSData(contentsOfURL: url!)
                    {
                        eventImage = UIImage(data: data)
                    }
                    
                    
                    //getting event latitude and longitude (Have to do annoying long cast from string to float value)
                    var eventLat:Float = NSString(string: (e["venue"]["location"]["geo:point"]["geo:lat"].stringValue)).floatValue
                    var eventLong:Float = NSString(string: (e["venue"]["location"]["geo:point"]["geo:long"].stringValue)).floatValue
                    
                    //add each event to our table
                    var event = MusicEvent(name:eventTitle, lat: eventLat, long: eventLong, venueCity: eventCity, venueName: eventVenue, venueAddress: eventAddress, venueImage: eventImage!)
                    musicEvents.append(event)

                }
                
                //all done? call back to the main thread
                dispatch_async(dispatch_get_main_queue(),
                {
                    self.searchIndicator.stopAnimating()
                    //seeing if our search did not result in any data. If so inform the user no results were found
                    if(musicEvents.count < 2)
                    {
                        musicEvents.removeAll(keepCapacity: false)
                        var event = MusicEvent(name: "No results found", lat: 0.0, long: 0.0, venueCity: "", venueName: "", venueAddress: "", venueImage: UIImage())
                        musicEvents.append(event)
                        
                        self.emptySearchResult = true
                        self.tableView.reloadData()
                        
                    }
                    else
                    {
                        //update the UI
                        self.emptySearchResult = false
                        self.tableView.reloadData()
                    }
                })
                
            print(json)
        })
        
        dataTask.resume()
        
    }

}

