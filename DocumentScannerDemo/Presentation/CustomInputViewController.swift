//
//  CustomInputViewController.swift
//  DocumentScannerDemo
//
//  Created by Rehnuma Reza Deepty on 30/11/23.
//

import Foundation
import UIKit

class CustomInputViewController: UIInputViewController {
    let buttonTitles = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["✕","0", "⏎"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomInputView()
    }
    
    func addCustomInputView() {
        let keyboardView = UIView(frame: CGRectMake(0.0, 0, UIScreen.main.bounds.width, 300))
        keyboardView.backgroundColor = .systemBackground
        view = keyboardView
        
        var stackViews: [UIStackView] = []
        
        for titleSet in buttonTitles {
            stackViews.append(createStackView(with: titleSet))
        }
        
        let stackView = UIStackView(arrangedSubviews: stackViews)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        keyboardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: keyboardView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: keyboardView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: keyboardView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: -8),
        ])
        
    }
    
    private func createStackView(with items: [String]) -> UIStackView {
        var buttons: [UIButton] = []
        for item in items {
            buttons.append( createButton(with: item))
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 10
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        return button
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let text = sender.title(for: .normal),
              let proxy = textDocumentProxy as? UITextDocumentProxy
        else { return }
        
        proxy.insertText(text)
        
        print(text)
    }
}
