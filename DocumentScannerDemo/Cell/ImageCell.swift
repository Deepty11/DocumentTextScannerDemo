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
    var analyzer = ImageAnalyzer()
    var interaction = ImageAnalysisInteraction()
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImageView.layer.cornerRadius = 10
        cellImageView.addInteraction(interaction)
        configureLiveTextInteraction()
    }
    
    func configureLiveTextInteraction() {
        Task {
            let configuration = ImageAnalyzer.Configuration([.text])
            
            guard let image = cellImageView.image else { return }
            
            do {
                let analysis = try await analyzer.analyze(image, configuration: configuration)
                
                interaction.analysis = analysis
                interaction.preferredInteractionTypes = .automaticTextOnly
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func setImage(image: UIImage) {
        cellImageView.image = image
    }
}
