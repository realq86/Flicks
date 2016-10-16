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
private let imageBaseURL92px = "https://image.tmdb.org/t/p/w92"
private let imageBaseURL150px = "https://image.tmdb.org/t/p/w150"
class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    //NetworkError IBOutlets
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movieListArray = [AnyObject]()
    var playNowOrTopRated:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRefreshControl()
        self.setupTableView()
        self.setupCollectionView()
        
        self.apiCall {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
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
    
    // MARK: - API Call
    func apiCall(reloadBlock: @escaping ()->()) {
        
        if playNowOrTopRated == "PLAYNOW" {
            self.playingNowApiCall {
                reloadBlock()
            }
        }
        else {
            self.topRatedApiCall {
                reloadBlock()
            }
        }
    }
    
    func playingNowApiCall(_ completionHandler:@escaping ()->()) {
        let moveDB = MovieDBServer.sharedInstance
        
        CircularSpinner.useContainerView(self.view)
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
        moveDB.getPlayingNow { (jsonResponse:Array<AnyObject>, error:Error?) in
            
            if (error == nil) {
                self.movieListArray = jsonResponse
//                self.tableView.reloadData()
                completionHandler()
                self.networkErrorView.isHidden = true
            }
            else {
                self.networkErrorView.isHidden = false
            }
            CircularSpinner.hide()
        }
    }
    
    func topRatedApiCall(_ completionHandler:@escaping ()->()) {
        let moveDB = MovieDBServer.sharedInstance
        
        CircularSpinner.useContainerView(self.view)
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
        moveDB.getTopRated { (jsonResponse:Array<AnyObject>, error:Error?) in
            
            if (error == nil) {
                self.movieListArray = jsonResponse
//                self.tableView.reloadData()
                completionHandler()
                self.networkErrorView.isHidden = true
            }
            else {
                self.networkErrorView.isHidden = false
            }
            CircularSpinner.hide()
        }
    }
    
    // MARK: - UIRefreshControl
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlPulled(_:)), for: .valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
    }
    func refreshControlPulled(_ refreshControl:UIRefreshControl) {
        
        self.apiCall {
            refreshControl.endRefreshing()
        }
        
    }

    // MARK: - Table View Code
    
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
        //Set Movie Overview
        if let movieOverviewString = self.movieListArray[indexPath.row].value(forKeyPath: "overview") as? String {
            cell?.movieOverview.text = movieOverviewString
        }
        
        //Set Movie Image
        if let imagePathString = self.movieListArray[indexPath.row].value(forKeyPath: "poster_path") as? String {
            
            self.set(imageView: (cell?.movieImageView), withURL: imagePathString)

        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func set(imageView:UIImageView? , withURL imagePathString:String) {
        
        guard let urlForSmall  = URL(string: "\(imageBaseURL150px)" + imagePathString)
            else {
                return
        }
        let smallURLRequest = URLRequest(url: urlForSmall)
        
        guard let urlForLarge  = URL(string: "\(imageBaseURL150px)" + imagePathString)
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
    
    // MARK: - CollectionView
    
    func setupCollectionView() {
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieListArray.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as? MovieCollectionCell
        
        //Set Movie Title
        if let movieTitleString = self.movieListArray[indexPath.row].value(forKeyPath: "original_title") as? String {
            
            cell?.movieTitle.text = movieTitleString
        }
        
        //Set Movie Image
        if let imagePathString = self.movieListArray[indexPath.row].value(forKeyPath: "poster_path") as? String {
            
            self.set(imageView: (cell?.movieImageView), withURL: imagePathString)
            
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 3
        
        return CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        if (oddEven == 0) {
//            return CGSize(width: dimensions, height: dimensions)
//        } else {
//            return CGSize(width: dimensions, height: dimensions / 2)
//        }
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
