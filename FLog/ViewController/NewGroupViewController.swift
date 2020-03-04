//
//  NewGroupViewController.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class NewGroupViewController: KUIViewController  {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        cancelsTouchesInView = true
        
        super.viewDidLoad()
        
        nameTextField.delegate = self
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
        if nameTextField.text!.count == 0 {
            Common.View.showAlertWithOneButton(viewController: self, title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: { (_) in
            })
        } else {
            var routines = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)
            var dict: Dictionary = Dictionary<String, Any>()
            
            for routine in routines! {
                let routineDict = routine as! Dictionary<String, Any>
                if routineDict[Common.Define.mainRoutineTitle] as? String == nameTextField.text {
                    Common.View.showAlertWithOneButton(viewController: self, title: "Failed", message: (nameTextField.text ?? "") + " already exists\nPlease enter another name", buttonTitle: "OK", handler: { (_) in
                    })
                    return
                }
            }
            
            dict[Common.Define.mainRoutineTitle] = nameTextField.text
            
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                dict[Common.Define.mainRoutineUnit] = Common.Define.mainRoutineUnitKg
            } else {
                dict[Common.Define.mainRoutineUnit] = Common.Define.mainRoutineUnitLb
            }
            
            var array: Array<String> = []
            for view in stackView.arrangedSubviews {
                let horizontalStackView = view as! UIStackView
                let textField = horizontalStackView.arrangedSubviews[1] as! UITextField
                if textField.text!.count == 0 {
                    Common.View.showAlertWithOneButton(viewController: self, title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: { (_) in
                    })
                    return
                }
                
                array.append(textField.text!)
            }
            
            dict[Common.Define.mainRoutineExercises] = array
            routines?.append(dict)
            
            UserDefaults.standard.set(routines, forKey: Common.Define.mainRoutine)
            

            var bestDict = Dictionary<String, Dictionary<String, String>>()
            for exercise in array {
                bestDict[exercise] = Dictionary<String, String>()
                bestDict[exercise]![Common.Define.mainRoutineUnit] = dict[Common.Define.mainRoutineUnit] as? String
                bestDict[exercise]![Common.Define.routineBestMaxVolume] = "0"
                bestDict[exercise]![Common.Define.routineBestMaxVolumeDate] = ""
                bestDict[exercise]![Common.Define.routineBestMaxWeight] = "0"
                bestDict[exercise]![Common.Define.routineBestMaxWeightDate] = ""
            }
            UserDefaults.standard.set(bestDict, forKey: nameTextField.text! + Common.Define.routineBest)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
