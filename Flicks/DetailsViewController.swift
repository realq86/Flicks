//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Developer on 10/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AFNetworking

private let imageBaseURL500px = "https://image.tmdb.org/t/p/w500"

private let original_title_path = "original_title"
private let poster_URL_path = "poster_path"
private let overview_path = "overview"
private let release_date_path = "release_date"
private let vote_average_path = "vote_average"
class DetailsViewController: UIViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movieJson:AnyObject!
    var titleString: String?
    var backgroundImageURL:String?
    var overviewString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parseJsonDic(self.movieJson)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJsonDic(_ movieJson:AnyObject) {
        
        //Set Movie Title
        if let movieTitleString = movieJson.value(forKeyPath: original_title_path) as? String {
            
            self.titleLabel.text = movieTitleString
        }
        
        //Set Movie Image
        if let imagePathString = movieJson.value(forKeyPath: poster_URL_path) as? String {
            
            let imageURLString = "\(imageBaseURL500px)" + imagePathString
            self.backgroundImageView.setImageWith(URL(string: imageURLString)!)
        }
        
        //Set Movie Overview
        if let movieOverviewString = movieJson.value(forKeyPath:overview_path) as? String {
            self.overviewLabel.text = movieOverviewString
        }
        
        //Set Movie Date
        if let movieDateString = movieJson.value(forKeyPath: release_date_path) as? String {
            self.dateLabel.text = "Release: " + movieDateString
        }
        
        //Set Ratings
        if let movieRating = movieJson.value(forKeyPath: vote_average_path) as? Float {
            self.ratingLabel.text = "Rating: "+String(movieRating)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
