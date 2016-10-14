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
        if let movieTitleString = movieJson.value(forKeyPath: "original_title") as? String {
            
            self.titleLabel.text = movieTitleString
        }
        
        //Set Movie Image
        if let imagePathString = movieJson.value(forKeyPath: "poster_path") as? String {
            
            let imageURLString = "\(imageBaseURL500px)" + imagePathString
            self.backgroundImageView.setImageWith(URL(string: imageURLString)!)
        }
        
        //Set Movie Overview
        if let movieOverviewString = movieJson.value(forKeyPath: "overview") as? String {
            self.overviewLabel.text = movieOverviewString
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
