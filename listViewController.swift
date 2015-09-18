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

//        Edit url for higher res images
        let range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        let imageUrl = NSURL(string: urlString)
        
        let cell = movieTableView.dequeueReusableCellWithIdentifier("rotten.listTableCell", forIndexPath: indexPath) as! movieTableViewCell
//        cell.movieImageView.setImageWithURLRequest(imageUrl!, placeholderImage: moviePlaceholder, success: <#T##((NSURLRequest, NSHTTPURLResponse, UIImage) -> Void)?##((NSURLRequest, NSHTTPURLResponse, UIImage) -> Void)?##(NSURLRequest, NSHTTPURLResponse, UIImage) -> Void#>, failure: <#T##((NSURLRequest, NSHTTPURLResponse, NSError) -> Void)?##((NSURLRequest, NSHTTPURLResponse, NSError) -> Void)?##(NSURLRequest, NSHTTPURLResponse, NSError) -> Void#>)
        cell.movieImageView.setImageWithURL(imageUrl!, placeholderImage: moviePlaceholder)

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
        
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let d = data {
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                self.movieList = responseDictionary["movies"] as? NSArray
                self.movieTableView.reloadData()
                self.loader.dismiss()
            } else {
                if let e = error {
                    NSLog("Error: \(e)")
                }
            }
            self.refreshControl.endRefreshing()
        }
    }

    
}




