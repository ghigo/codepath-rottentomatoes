//
//  listViewController.swift
//  rotten tomatoes
//
//  Created by Marco Sgrignuoli on 9/17/15.
//  Copyright © 2015 Optimizely. All rights reserved.
//

import UIKit

class listViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movieList: NSArray? // List of movies from API
    
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self


//        Load images
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let d = data {
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                self.movieList = responseDictionary["movies"] as? NSArray
                self.movieTableView.reloadData()
//                self.refreshControl.endRefreshing()
            } else {
                if let e = error {
                    NSLog("Error: \(e)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
//    Table View Source stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let images = movieList {
            NSLog("tot images: \(images.count)")
            return images.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let photo = photoDictionary![indexPath.row] as! NSDictionary
//        let photoImage = photo.valueForKeyPath("images.low_resolution.url") as! String
//        let imageUrl = NSURL(string: photoImage)
//        let cell = photoTableView.dequeueReusableCellWithIdentifier("photoGrid", forIndexPath: indexPath) as! PhotoTableViewCell
//        cell.photoImageView.setImageWithURL(imageUrl!)
//        return cell
    
        let movieObj = movieList![indexPath.row] as! NSDictionary
        var urlString = movieObj.valueForKeyPath("posters.thumbnail") as! String

        
        var range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        let imageUrl = NSURL(string: urlString)
        
        let cell = movieTableView.dequeueReusableCellWithIdentifier("rotten.listTableCell", forIndexPath: indexPath) as! movieTableViewCell
        cell.movieImageView.setImageWithURL(imageUrl!)
//        cell.movieImageView.setImage
        
        
//                let cell = photoTableView.dequeueReusableCellWithIdentifier("rotten.listTableCell", forIndexPath: indexPath) as! PhotoTableViewCell
        return cell
    }

}




