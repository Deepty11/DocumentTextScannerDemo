//
//  ViewController.swift
//  DocumentScannerDemo
//
//  Created by Rehnuma Reza Deepty on 29/11/23.
//

import UIKit
import VisionKit

class ViewController: UIViewController {
    var customInputView = CustomInputViewController()
    var documentInputViewController = DocumentInputViewController()
    
    var images: [UIImage] = []
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Scan Document", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Scan your Doc"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "write something"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
    
    private func setSubViews() {
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(textField)
        
        //textField.inputView = customInputView.view
        textField.inputView = documentInputViewController.view
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textField.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10),
            
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 55),
            
        ])
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNumber in 0..<scan.pageCount {
            images.append(scan.imageOfPage(at: pageNumber))
        }
        
        documentInputViewController.images = images
        documentInputViewController.reloadInputViews()
        
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}

