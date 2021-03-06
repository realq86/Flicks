//
//  movieCollectionCell.swift
//  Flicks
//
//  Created by Developer on 10/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    override func prepareForReuse() {
        self.movieImageView.image = nil
        self.movieTitle.text = nil
    }
    
}
