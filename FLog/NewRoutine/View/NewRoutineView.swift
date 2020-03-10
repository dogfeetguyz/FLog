//
//  NewGroupViewController.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class NewRoutineView: KUIViewController  {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    var presenter: NewRoutinePresenterProtocol?
    
    override func viewDidLoad() {
        cancelsTouchesInView = true // must be called before super.viewDidLoad() called
        super.viewDidLoad()
        nameTextField.delegate = self
        
        presenter?.viewDidLoad()
    }
    
    @IBAction func addButtonAction() {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 0
        
        let newLabel = UILabel()
        newLabel.text = String(format: "Exercise %d", stackView.arrangedSubviews.count + 1)
        newLabel.widthAnchor.constraint(equalToConstant: 95).isActive = true
        horizontalStack.addArrangedSubview(newLabel)
        
        let newTextField = UITextField()
        newTextField.placeholder = "e.g., Back Squat, Bench Press, Deadlift"
        newTextField.borderStyle = .roundedRect
        newTextField.font = .systemFont(ofSize: 12)
        newTextField.autocapitalizationType = .words
        newTextField.delegate = self
        horizontalStack.addArrangedSubview(newTextField)
        
        stackView.addArrangedSubview(horizontalStack)
        
        removeButton.isEnabled = true
    }
    
    @IBAction func removeButtonAction() {
        stackView.arrangedSubviews[stackView.arrangedSubviews.count-1].removeFromSuperview()
        if (stackView.arrangedSubviews.count == 1) {
            removeButton.isEnabled = false
        }
    }
    
    @IBAction func createButtonAction() {

        var array: Array<String?> = []
        for view in stackView.arrangedSubviews {
            let horizontalStackView = view as! UIStackView
            let textField = horizontalStackView.arrangedSubviews[1] as! UITextField
            array.append(textField.text!)
        }
        
        presenter?.clickCreateButton(title: nameTextField.text!, unitIndex: unitSegmentedControl.selectedSegmentIndex, routine:array)
    }
}

extension NewRoutineView: NewRoutineViewProtocol {
    func showError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        Common.View.showAlertWithOneButton(viewController: self, title: title, message: message, buttonTitle: buttonTitle, handler: handler)
    }
}
