//
//  DocumentInputViewController.swift
//  DocumentScannerDemo
//
//  Created by Rehnuma Reza Deepty on 3/12/23.
//

import Foundation
import UIKit
import VisionKit

class DocumentInputViewController: UIInputViewController {
    var analyzer = ImageAnalyzer()
    var interaction = ImageAnalysisInteraction()
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let cV = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cV.register(UINib(nibName: ImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageCell.identifier)
        cV.backgroundColor = .gray
        cV.dataSource = self
        cV.delegate = self
        
        return cV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [UIImage(named: "image1")!,
                  UIImage(named: "image2")!,
                  UIImage(named: "image3")!,
                  UIImage(named: "image4")!]
        addCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func addCollectionView() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400))
        view = container
        
        container.addSubview(collectionView)
        container.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: container.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {[weak self] _,_ in
            self?.createSection()
        }
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(300)),
            repeatingSubitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 4,
            bottom: 4,
            trailing: 4)
        
        return section
    }
    
}

extension DocumentInputViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        cell.setImage(image: images[indexPath.row])
        return cell
    }
    
}
