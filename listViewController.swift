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
    let loader = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    let refreshControl = UIRefreshControl()
    let moviePlaceholder = UIImage(named: "moviePlaceholder")
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var networkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.textLabel.text = "loading"
        
//        Setup refresh
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        movieTableView.insertSubview(refreshControl, atIndex: 0)
        
//        Setup delegate and dataSource
        movieTableView.dataSource = self
        movieTableView.delegate = self
        


//        Load images
        refresh()
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
        let movieObj = movieList![indexPath.row] as! NSDictionary
        var urlString = movieObj.valueForKeyPath("posters.thumbnail") as! String
        let thumbnailUrl = NSURL(string: urlString)
        let thumbnailRequest = NSURLRequest(URL: thumbnailUrl!)

//        Edit url for higher res images
        let range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        let largeImageUrl = NSURL(string: urlString)
        
        let cell = movieTableView.dequeueReusableCellWithIdentifier("rotten.listTableCell", forIndexPath: indexPath) as! movieTableViewCell
        
        func onThumbnailLoaded(request: NSURLRequest, response: NSHTTPURLResponse, movieImage: UIImage) {
//            Set tumbnail
            cell.movieImageView.image = movieImage
//            Load large image
            cell.movieImageView.setImageWithURL(largeImageUrl!)
        }
//        Load thumbnail
        cell.movieImageView.setImageWithURLRequest(thumbnailRequest, placeholderImage: moviePlaceholder, success: onThumbnailLoaded, failure: nil)

//        Remove side arrow from cell
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        movieTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! detailsViewController
        let indexPath = movieTableView.indexPathForCell(sender as! UITableViewCell)
        vc.selectedMovie = movieList![(indexPath?.row)!] as? NSDictionary
    }
    
    func refresh() {
//        Show loader
        self.loader.showInView(movieTableView)
        self.networkView.hidden = true
        
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let d = data {
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                self.movieList = responseDictionary["movies"] as? NSArray
                self.movieTableView.reloadData()
            } else {
                self.networkView.hidden = false
                if let e = error {
                    NSLog("Error: \(e)")
                }
            }
            self.loader.dismiss()
            self.refreshControl.endRefreshing()
        }
    }

    
}




