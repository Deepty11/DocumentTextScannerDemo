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
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "write something"
        return textField
    }()
    
    var bar: UIToolbar = {
        let bar = UIToolbar()
        let resetButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.2.swap"),
                                          style: .done,
                                          target: ViewController.self,
                                          action: #selector(swapInputView))
        bar.items = [resetButton]
        bar.sizeToFit()
        
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        
        button.addTarget(self, 
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(viewDidTapped)))
    }
    
    @objc private func viewDidTapped() {
        textField.resignFirstResponder()
    }
    
    @objc private func buttonTapped() {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
    
    @objc private func swapInputView() {
        let previousInputView = textField.inputView
        textField.inputView = nil
        textField.resignFirstResponder()
        
        if previousInputView == documentInputViewController.view {
            textField.becomeFirstResponder()
        } else {
            textField.inputView = documentInputViewController.view
        }
    }
    
    private func addToolBar() {
        let bar = UIToolbar()
        let resetButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.2.swap"),
                                          style: .done,
                                          target: self,
                                          action: #selector(swapInputView))
        bar.items = [resetButton]
        bar.sizeToFit()
        
        textField.inputAccessoryView = bar
    }
    
    private func setSubViews() {
        view.addSubview(button)
        view.addSubview(textField)
        
        textField.inputView = documentInputViewController.view
        addToolBar()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -40),
            
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
        
        documentInputViewController.images.append(contentsOf: images)
        
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}

