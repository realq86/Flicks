//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Developer on 10/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AFNetworking
import CircularSpinner

private let imageBaseURL500px = "https://image.tmdb.org/t/p/w500"

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: NetworkError IBOutlets
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movieListArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRefreshControl()
        self.setupTableView()
        
        self.apiCAll {  }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.networkErrorView.isHidden = true
    }
    
    // MARK: API Call
    func apiCAll(_ completionHandler:@escaping ()->()) {
        let moveDB = MovieDBServer.sharedInstance
        
        CircularSpinner.useContainerView(self.view)
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
        moveDB.getPlayingNow { (jsonResponse:Array<AnyObject>, error:Error?) in
            
            if (error == nil) {
                self.movieListArray = jsonResponse
                self.tableView.reloadData()
                completionHandler()
                self.networkErrorView.isHidden = true
            }
            else {
                self.networkErrorView.isHidden = false
            }
            CircularSpinner.hide()
        }
    }
    
    // MARK: UIRefreshControl
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlPulled(_:)), for: .valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
    }
    func refreshControlPulled(_ refreshControl:UIRefreshControl) {
        
        self.apiCAll {
            refreshControl.endRefreshing()
        }
        
    }

    // MARK: Table View Code
    
    func setupTableView() {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieListArray.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell
        
        //Set Movie Title
        if let movieTitleString = self.movieListArray[indexPath.row].value(forKeyPath: "original_title") as? String {
        
            cell?.movieTitle.text = movieTitleString
        }
        
        //Set Movie Image
        if let imagePathString = self.movieListArray[indexPath.row].value(forKeyPath: "poster_path") as? String {
            
            let imageURLString = "\(imageBaseURL500px)" + imagePathString
            cell?.movieImageView.setImageWith(URL(string: imageURLString)!)
        }
        
        //Set Movie Overview
        if let movieOverviewString = self.movieListArray[indexPath.row].value(forKeyPath: "overview") as? String {
            cell?.movieOverview.text = movieOverviewString
        }
        
        cell?.sizeToFit()
        return cell!
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? MovieCell {
        
            if let currentIndexPath = tableView.indexPath(for: cell) {
                
                let movie = self.movieListArray[currentIndexPath.row]
                if let detailVC = segue.destination as? DetailsViewController {
                    detailVC.movieJson = movie
                }
            }
        }
        
    }


}
