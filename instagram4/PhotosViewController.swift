//
//  PhotosViewController.swift
//  instagram4
//
//  Created by Saul Soto on 1/23/16.
//  Copyright © 2016 CodePath - Saul Soto. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //var isMoreDataLoading = false
    //var loadingMoreView:InfiniteScrollActivityView?
    
    var instaImages: [NSDictionary]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 320;
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.instaImages = responseDictionary["data"] as! [NSDictionary]
                    /*NSLog("response: \(responseDictionary)")*/
                    }
                }
                self.tableView.reloadData()
                
        });
        task.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let instaImages = instaImages {
            return instaImages.count
        } else {
            return 0
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.codepath.DemoPrototypeCell", forIndexPath: indexPath) as! DemoPrototypeCell
        
        let instaImage = instaImages![indexPath.row]
        
        let imageUrl = NSURL(string: instaImage.valueForKeyPath("images.standard_resolution.url") as! String)
        
        //Following codeblock implemented by fellow CodePath peer Monte9
        if let usertext = instaImage.valueForKeyPath("user.username") as? String
        {
            cell.userName.text =  usertext
        }
        else
        {
            cell.userName.text = "0"
        }
        
        cell.instaPhoto.setImageWithURL(imageUrl!)
        
        if let userpicURL = NSURL (string: instaImage.valueForKeyPath("user.profile_picture") as! String)
        {
            cell.userFace.setImageWithURL(userpicURL)
            cell.userFace.layer.cornerRadius = cell.userFace.frame.height/2;
            cell.userFace.clipsToBounds = true;
        }

        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url2 = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let myRequest = NSURLRequest(URL: url2!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.instaImages = responseDictionary["data"] as! [NSDictionary]
                            
                // ... Use the new data to update the data source ...
                
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
        
        //print("hello world")
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

