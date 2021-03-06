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
class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //NetworkError IBOutlets
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var filteredMovieListArray = [AnyObject]()
    var totalMovieListArray = [AnyObject]()
    var playNowOrTopRated:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupRefreshControl()
        self.setupTableView()
        self.setupCollectionView()
        
        self.segmentControlTouched(self.segmentControl)
        
        self.apiCall {
            self.tableView.reloadData()
            self.collectionView.reloadData()
            self.searchBar(self.searchBar, textDidChange: "")
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
                self.totalMovieListArray = jsonResponse
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
                self.totalMovieListArray = jsonResponse
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
        let tablerRefreshControl = UIRefreshControl()
        tablerRefreshControl.addTarget(self, action: #selector(refreshControlPulled(_:)), for: .valueChanged)
        self.tableView.insertSubview(tablerRefreshControl, at: 0)
        
        let collectionRefreshControl = UIRefreshControl()
        collectionRefreshControl.addTarget(self, action: #selector(refreshControlPulled(_:)), for: .valueChanged)
        self.collectionView.insertSubview(collectionRefreshControl, at: 0)
    }
    
    func refreshControlPulled(_ refreshControl:UIRefreshControl) {
        
        self.apiCall {
            self.tableView.reloadData()
            self.collectionView.reloadData()
            self.searchBar(self.searchBar, textDidChange: "")
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
        return self.filteredMovieListArray.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell
        
        //Set Movie Title
        if let movieTitleString = self.filteredMovieListArray[indexPath.row].value(forKeyPath: "original_title") as? String {
            cell?.movieTitle.text = movieTitleString
        }

        //Set Movie Overview
        if let movieOverviewString = self.filteredMovieListArray[indexPath.row].value(forKeyPath: "overview") as? String {
            cell?.movieOverview.text = movieOverviewString
        }
        
        //Set Movie Image
        if let imagePathString = self.filteredMovieListArray[indexPath.row].value(forKeyPath: "poster_path") as? String {
            self.set(imageView: (cell?.movieImageView), withURL: imagePathString)
        }
        
        cell?.selectionStyle = .default
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
        cell?.selectedBackgroundView = backgroundView
        
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
        return self.filteredMovieListArray.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as? MovieCollectionCell
        
        //Set Movie Title
        if let movieTitleString = self.filteredMovieListArray[indexPath.row].value(forKeyPath: "original_title") as? String {
            cell?.movieTitle.text = movieTitleString
        }

        
        //Set Movie Image
        if let imagePathString = self.filteredMovieListArray[indexPath.row].value(forKeyPath: "poster_path") as? String {
            self.set(imageView: (cell?.movieImageView), withURL: imagePathString)
        }        
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.white
        cell?.selectedBackgroundView = selectedView
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 3
//        let oddEven = indexPath.row / numberOfCellsPerRow % 2
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow-7)
        
        return CGSize(width: dimensions, height: dimensions)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
// OTHER OPTION OF CELL SELECTION ANIMATION
//        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionCell {
//            
//            UIView.animate(withDuration: 0.3,
//                           animations: {
//                                cell.movieImageView.isHidden = true
//
//                            },
//                           completion: { (complete:Bool) in
//                    
//                            })
//            
//        }
    }
    
    
    // MARK - SegmentControl
    @IBAction func segmentControlTouched(_ sender: UISegmentedControl) {
        self.tableView.isHidden = true
        self.collectionView.isHidden = true
        
        if segmentControl.selectedSegmentIndex == 0 {
            self.tableView.isHidden = false
        }
        if segmentControl.selectedSegmentIndex == 1 {
            self.collectionView.isHidden = false
        }
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tableViewCellSegue" {
        
            if let cell = sender as? MovieCell {
            
                if let currentIndexPath = self.tableView.indexPath(for: cell) {
                    
                    let movie = self.filteredMovieListArray[currentIndexPath.row]
                    if let detailVC = segue.destination as? DetailsViewController {
                        detailVC.movieJson = movie
                    }
                }
            }
        }
        
        if segue.identifier == "collectionCellSegue" {
            if let cell = sender as? MovieCollectionCell {
                if let currentIndexPath = self.collectionView.indexPath(for: cell) {
                    
                    let movie = self.filteredMovieListArray[currentIndexPath.row]
                    if let detailVC = segue.destination as? DetailsViewController {
                        detailVC.movieJson = movie
                    }
                }
            }
        }
    }

    // MARK - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            self.filteredMovieListArray = self.totalMovieListArray
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            self.filteredMovieListArray = self.totalMovieListArray.filter({(dataItem: AnyObject) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let titleString = dataItem.value(forKeyPath: "original_title") as? String
                if titleString?.range(of: searchText, options: .caseInsensitive) != nil {
                    return true
                } else {
                    return false
                }
                
            })
        }
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.searchBar(searchBar, textDidChange: searchBar.text!)
        searchBar.resignFirstResponder()
    }
}
