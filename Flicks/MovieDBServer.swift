//
//  MovieDBServer.swift
//  Flicks
//
//  Created by Developer on 10/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AFNetworking

private let movieDBAPIKey = ["api_key":"a07e22bc18f5cb106bfe4cc1f83ad8ed"]
private let baseURL = "https://api.themoviedb.org/3/movie"
private let nowPlayingEndPoint = "/now_playing"
private let topRatedEndPoint = "/top_rated"

class MovieDBServer: NSObject {

    static let sharedInstance = MovieDBServer()
    
    var nowPlayingResponse = [String:AnyObject]()
    var nowPlayingArray = [AnyObject]()
    
    override init() {
        print("Init MovieDBServer Singleton")
    }
    
    func getPlayingNow(_ responseBlock: @escaping (Array<AnyObject>, Error?)->()) {
        
        let nowPlayingURL = "\(baseURL)\(nowPlayingEndPoint)"
        
        let manager = AFHTTPSessionManager()
        
        manager.get(nowPlayingURL,
                    parameters: movieDBAPIKey,
                    progress: { (progress:Progress) in
            },
                    success: { (task:URLSessionDataTask, response:Any?) in
                                                
                        if let response = response as? Dictionary<String, AnyObject> {
                            
                            self.nowPlayingResponse = response
                            self.nowPlayingArray = self.nowPlayingResponse["results"] as! [AnyObject]
                            print("Array     \(self.nowPlayingArray)")
                        }
                        responseBlock(self.nowPlayingArray, nil)
            },
                    failure:{ (task:URLSessionDataTask?, error:Error) in
                        print(error.localizedDescription)
                        responseBlock(self.nowPlayingArray, error)
        })
    }
    
    func getTopRated(_ responseBlock: @escaping (Array<AnyObject>, Error?)->()) {
        
        let nowPlayingURL = "\(baseURL)\(topRatedEndPoint)"
        
        let manager = AFHTTPSessionManager()

        manager.get(nowPlayingURL,
                    parameters: movieDBAPIKey,
                    progress: { (progress:Progress) in
            },
                    success: { (task:URLSessionDataTask, response:Any?) in
                        
                        if let response = response as? Dictionary<String, AnyObject> {
                            
                            self.nowPlayingResponse = response
                            self.nowPlayingArray = self.nowPlayingResponse["results"] as! [AnyObject]
                            print("Array     \(self.nowPlayingArray)")
                        }
                        responseBlock(self.nowPlayingArray, nil)
            },
                    failure:{ (task:URLSessionDataTask?, error:Error) in
                        print(error.localizedDescription)
                        responseBlock(self.nowPlayingArray, error)
        })
    }
}
