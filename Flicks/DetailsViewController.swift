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
private let imageBaseURL92px = "https://image.tmdb.org/t/p/w92"
private let imageBaseURL150px = "https://image.tmdb.org/t/p/w150"
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
        
        //Set Movie Title
        if let movieTitleString = movieJson.value(forKeyPath: original_title_path) as? String {
            
            self.navigationItem.title = movieTitleString
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"Back"), style: .plain, target: self, action: #selector(popViewController(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.gray
        
        // Do any additional setup after loading the view.
    }

    func popViewController(_ sender:AnyObject) {
        self.navigationController?.popViewController(animated: true)
        print(self.navigationController)
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
            
//            let imageURLString = "\(imageBaseURL500px)" + imagePathString
//            self.backgroundImageView.setImageWith(URL(string: imageURLString)!)
            
            self.set(imageView: self.backgroundImageView, withURL: imagePathString)
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
    
    func set(imageView:UIImageView? , withURL imagePathString:String) {
        
        guard let urlForSmall  = URL(string: "\(imageBaseURL150px)" + imagePathString)
            else {
                return
        }
        let smallURLRequest = URLRequest(url: urlForSmall)
        
        guard let urlForLarge  = URL(string: "\(imageBaseURL500px)" + imagePathString)
            else {
                return
        }
        imageView?.setImageWith(smallURLRequest,
                                placeholderImage: nil,
                                success: { (smallURLRequest, smallResponse, image:UIImage) in
                                    
                                    imageView?.alpha = 0.0
                                    imageView?.image = image
                                    
                                    UIView.animate(withDuration: 0.3,
                                                   animations: {
                                                    imageView?.alpha = 1.0
                                        },
                                                   completion: { (success) in
                                                    imageView?.setImageWith(urlForLarge)
                                    })
                                    
                                    
            },
                                failure: { (smallURLRequest, smallResponse, error:Error) in
                                    print("Small Image Load Error \(error.localizedDescription)")
        })
        
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
