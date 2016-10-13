//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Developer on 10/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AFNetworking

private let movieDBAPIKey = ["api_key":"a07e22bc18f5cb106bfe4cc1f83ad8ed"]
private let baseURL = "https://api.themoviedb.org/3/movie"
private let nowPlayingEndPoint = "/now_playing"
//https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed
class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
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
    
        let nowPlayingURL = "\(baseURL)\(nowPlayingEndPoint)"
        
        let manager = AFHTTPSessionManager()
        
        manager.get(nowPlayingURL,
                    parameters: movieDBAPIKey,
                    progress: { (progress:Progress) in
                        
                    },
                    success: { (task:URLSessionDataTask, response:Any?) in
                        print(response.debugDescription)
                    },
                    failure:{ (task:URLSessionDataTask?, error:Error) in
                        print(error.localizedDescription)
                    })
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Text"
        
        return cell
        
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
