//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Developer on 10/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AFNetworking

private let imageBaseURL500px = "https://image.tmdb.org/t/p/w500"

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var movieListArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiCAll()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func apiCAll() {
        let moveDB = MovieDBServer.sharedInstance
        
        moveDB.getPlayingNow { (jsonResponse:Array<AnyObject>, error:Error?) in
            
            self.movieListArray = jsonResponse
            self.tableView.reloadData()
        }
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieListArray.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        return cell!
        
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
