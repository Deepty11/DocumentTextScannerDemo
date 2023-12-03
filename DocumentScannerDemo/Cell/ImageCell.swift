//
//  ImageCell.swift
//  DocumentScannerDemo
//
//  Created by Rehnuma Reza Deepty on 3/12/23.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImageView.layer.cornerRadius = 10
    }
    
    func setImage(image: UIImage) {
        cellImageView.image = image
    }
}
