//
//  ImageCell.swift
//  DocumentScannerDemo
//
//  Created by Rehnuma Reza Deepty on 3/12/23.
//

import UIKit
import VisionKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImageView.layer.cornerRadius = 10
    }
}
