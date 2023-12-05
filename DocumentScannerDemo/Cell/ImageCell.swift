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
    
    @IBOutlet weak var zoomableView: ZoomableImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        zoomableView.layer.cornerRadius = 10
    }
    
    func configureView(with image: UIImage) {
        zoomableView.imageView.image = image
    }
}
