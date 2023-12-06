//
//  ViewController.swift
//  DocumentScannerDemo
//
//  Created by Rehnuma Reza Deepty on 29/11/23.
//

import UIKit
import VisionKit

protocol InputViewDelegate: AnyObject {
    func addText(text: String)
}

class ViewController: UIViewController {
    var customInputView = CustomInputViewController()
    var documentInputViewController = DocumentInputViewController()
    
    var images: [UIImage] = []
    var textFields: [UITextField] = []
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Scan Document", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
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
    
    let numberOfTextFields = 3
    var selectedTextFieldTag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        
        button.addTarget(self, 
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(viewDidTapped)))
        documentInputViewController.delegate = self
    }
    
    @objc private func viewDidTapped() {
        view.endEditing(true)
    }
    
    @objc private func buttonTapped() {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
    
    @objc private func swapInputView() {
        for i in 0..<numberOfTextFields {
            let textField = textFields[i]
            if textField.isEditing {
                let previousInputView = textField.inputView
                textField.inputView = nil
                textField.resignFirstResponder()
                
                if !(previousInputView == documentInputViewController.view) {
                    textField.inputView = documentInputViewController.view
                }
                
                textField.becomeFirstResponder()
            }
        }
        
    }
    
    private func getToolBar() -> UIToolbar {
        let bar = UIToolbar()
        let resetButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.2.swap"),
                                          style: .done,
                                          target: self,
                                          action: #selector(swapInputView))
        bar.items = [resetButton]
        bar.sizeToFit()
        
        return bar
    }
    
    private func addTextFields() {
        for i in 0..<numberOfTextFields {
            let tf = UITextField()
            tf.borderStyle = .roundedRect
            tf.placeholder = "write something"
            tf.inputView = documentInputViewController.view
            tf.inputAccessoryView = getToolBar()
            tf.tag = i
            tf.delegate = self
            
            textFields.append(tf)
        }
    }
    
    private func setSubViews() {
        view.addSubview(button)
        
        addTextFields()
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 4
        
        view.addSubview(stackView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -40),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 55),
            
        ])
    }
}

//MARK: - VNDocumentCameraViewControllerDelegate
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

//MARK: - InputViewDelegate
extension ViewController: InputViewDelegate {
    func addText(text: String) {
        textFields[selectedTextFieldTag].text = text
    }
}


//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextFieldTag = textField.tag
    }
}

