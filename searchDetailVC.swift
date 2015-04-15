//
//  searchDetailVC.swift
//  DataDownloader
//
//  Created by Student on 4/7/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit
import MapKit
import Social

class searchDetailVC: UITableViewController {

    var selectedEvent:MusicEvent!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    //Sharing functionality to Facebook and Twitter
    @IBAction func shareButtonTapped(sender: AnyObject)
    {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        //Adding a cool blur effect
        var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        
        let facebook = UIAlertAction(title: "Facebook", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            var socialFB = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(socialFB, animated: true, completion: nil)
            socialFB.setInitialText("\(self.selectedEvent.getArtistName()) is playing at \(self.selectedEvent.getVenueAddress())")
            socialFB.addImage(self.selectedEvent.getVenueImage())
            
            blurView.removeFromSuperview()
            
        })
        
        let twitter = UIAlertAction(title: "Twitter", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            var socialTweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)

            self.presentViewController(socialTweet, animated: true, completion: nil)
            socialTweet.setInitialText("\(self.selectedEvent.getArtistName()) is playing at \(self.selectedEvent.getVenueAddress())")
            socialTweet.addImage(self.selectedEvent.getVenueImage())
            
            blurView.removeFromSuperview()
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            blurView.removeFromSuperview()
        })
        
        optionMenu.addAction(facebook)
        optionMenu.addAction(twitter)
        optionMenu.addAction(cancel)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCellWithIdentifier("selectedMusicEvent", forIndexPath: indexPath) as detailViewCell
 
        customCell.cityLabel.text? +=  selectedEvent.getCity()
        customCell.venueLabel.text? += selectedEvent.getVenueName()
        customCell.venueAddress.text? += selectedEvent.getVenueAddress()
        customCell.eventImage.image = selectedEvent.getVenueImage()
        
        return customCell
        
    }
    
    @IBAction func addFavoritesTapped(sender: AnyObject)
    {
        //favoritesArray.append(selectedEvent)
        print("tapped")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailViewToMap"
        {
            var mapView = segue.destinationViewController as MapViewController
            
            mapView.selectedEventCoordinates = selectedEvent.getCoordinates()
            mapView.region = MKCoordinateRegionMakeWithDistance(selectedEvent.getCoordinates(), 200000, 200000)
            mapView.isZoomedInView = true
        }
        else if segue.identifier == "showFavorites"
        {
            favoritesArray.append(selectedEvent)
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
