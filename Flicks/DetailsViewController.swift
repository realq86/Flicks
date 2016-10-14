//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Developer on 10/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AFNetworking
class DetailsViewController: UIViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var backgroundImageURL:String?
    var overviewString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImageView.setImageWith(URL(string: self.backgroundImageURL!)!)

        self.overviewLabel.text = overviewString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        print("BUTTON PRESSED!!!")
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
