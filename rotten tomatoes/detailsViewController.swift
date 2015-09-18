//
//  detailsViewController.swift
//  rotten tomatoes
//
//  Created by Marco Sgrignuoli on 9/17/15.
//  Copyright © 2015 Optimizely. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController {

    var selectedMovie: NSDictionary?
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        backgroundImage.setImageWithURL()
        
//        URL stuff
        var urlString = selectedMovie?.valueForKeyPath("posters.thumbnail") as! String
        
//        Edit url for higher res images
        let range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        let imageUrl = NSURL(string: urlString)
        backgroundImage.setImageWithURL(imageUrl!)
        
        titleLabel.text = selectedMovie?.valueForKeyPath("title") as! String
        
        synopsisLabel.text = selectedMovie?.valueForKeyPath("synopsis") as! String
        
//        let year_ = NSString(string: selectedMovie?.valueForKeyPath("year") as! Int)
        
        let year = String(format: "%d", (selectedMovie?.valueForKeyPath("year") as! Int))
        let aScore = String(format: "%d", (selectedMovie?.valueForKeyPath("ratings.audience_score"))as! Int)
        let cScore = String(format: "%d", (selectedMovie?.valueForKeyPath("ratings.critics_score") as! Int))
        detailsLabel.text = "Year: \(year), Critics score: \(cScore), Audience score: \(aScore)"
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

}
