//
//  MainTableViewCell.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineDetailTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var presenter: RoutineDetailPresenterProtocol?
    var exerciseLogData: ExerciseLogModel?
    var maxInfoData: Dictionary<String, Dictionary<String, String>>?
    var logDate: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exerciseStackView: UIStackView!
    @IBOutlet weak var bestVolumeImageView: UIImageView!
    @IBOutlet weak var bestWeightImageView: UIImageView!
    @IBOutlet weak var proportionLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var volumeProportionLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightUnitLabel: UILabel!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func resetStackView() {
        var firstItem = true
        for subview in exerciseStackView.arrangedSubviews {
            if firstItem {
                firstItem = false

                weightTextField.text = ""
                repsTextField.text = ""
                bestWeightImageView.isHidden = true
                proportionLabel.isHidden = true
                
                continue
            }
            subview.removeFromSuperview()
        }
    }
    
    func buildStackView() {

        calculateTotalVolume()
        updatePercentage()

        resetStackView()
        var firstItem = true
        
        for set in exerciseLogData!.set {
            if firstItem {
                firstItem = false
                weightTextField.text = set.weight
                repsTextField.text = set.reps
                
                let currentWeight = Int(set.weight) ?? 0
                let exerciseTitle = titleLabel.text ?? ""
                let maxWeight = Int(maxInfoData![exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0
                
                if (currentWeight > 0 && currentWeight >= maxWeight) {
                    bestWeightImageView.isHidden = false
                } else if (maxWeight > 0) {
                    proportionLabel.isHidden = false
                    proportionLabel.text = String(format: "%d%%", Int(100*(Float(currentWeight)/Float(maxWeight))))
                }
                
            } else {
                addStackView(weight: set.weight, reps: set.reps)
            }
        }
    }
    
    func addStackView(weight:String, reps:String) {
        
        let horizontalStack = UIStackView()
        horizontalStack.heightAnchor.constraint(equalToConstant: 34).isActive = true
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 5
        
        let setLabel = UILabel()
        setLabel.text = String(format: "Set %d", exerciseStackView.arrangedSubviews.count + 1)
        horizontalStack.addArrangedSubview(setLabel)
        
        let newBestImageView = UIImageView(image: UIImage(named: "icon_best"))
        newBestImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        newBestImageView.isHidden = true
        newBestImageView.contentMode = .scaleAspectFit
        horizontalStack.addArrangedSubview(newBestImageView)
        
        let newProportionLabel = UILabel()
        newProportionLabel.widthAnchor.constraint(equalToConstant: 34).isActive = true
        newProportionLabel.isHidden = true
        horizontalStack.addArrangedSubview(newProportionLabel)
        
        let currentWeight = Int(weight) ?? 0
        let exerciseTitle = titleLabel.text ?? ""
        let maxWeight = Int(maxInfoData![exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0
        if (currentWeight > 0 && currentWeight >= maxWeight) {
            newBestImageView.isHidden = false
        } else if (maxWeight > 0) {
            newProportionLabel.isHidden = false
            newProportionLabel.textColor = .link
            newProportionLabel.textAlignment = .right
            newProportionLabel.font = .systemFont(ofSize: 13)
            newProportionLabel.text = String(format: "%d%%", Int(100*(Float(currentWeight)/Float(maxWeight))))
        }
        
        let newWeightTextField = UITextField()
        newWeightTextField.widthAnchor.constraint(equalToConstant: 70).isActive = true
        newWeightTextField.borderStyle = .roundedRect
        newWeightTextField.textAlignment = .right
        newWeightTextField.font = .systemFont(ofSize: 12)
        newWeightTextField.autocapitalizationType = .none
        newWeightTextField.autocorrectionType = .no
        newWeightTextField.smartDashesType = .no
        newWeightTextField.smartInsertDeleteType = .no
        newWeightTextField.smartQuotesType = .no
        newWeightTextField.spellCheckingType = .no
        newWeightTextField.keyboardType = .numberPad
        newWeightTextField.tag = Int(String(format: "%d0", exerciseStackView.arrangedSubviews.count)) ?? 0
        newWeightTextField.text = weight
        newWeightTextField.delegate = self
        horizontalStack.addArrangedSubview(newWeightTextField)
        
        let newWeightUnitLabel = UILabel()
        newWeightUnitLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        newWeightUnitLabel.text = weightUnitLabel.text
        horizontalStack.addArrangedSubview(newWeightUnitLabel)
        
        let newRepsTextField = UITextField()
        newRepsTextField.widthAnchor.constraint(equalToConstant: 70).isActive = true
        newRepsTextField.borderStyle = .roundedRect
        newRepsTextField.textAlignment = .right
        newRepsTextField.font = .systemFont(ofSize: 12)
        newRepsTextField.autocapitalizationType = .none
        newRepsTextField.autocorrectionType = .no
        newRepsTextField.smartDashesType = .no
        newRepsTextField.smartInsertDeleteType = .no
        newRepsTextField.smartQuotesType = .no
        newRepsTextField.spellCheckingType = .no
        newRepsTextField.keyboardType = .numberPad
        newRepsTextField.tag = Int(String(format: "%d1", exerciseStackView.arrangedSubviews.count)) ?? 0
        newRepsTextField.text = reps
        newRepsTextField.delegate = self
        horizontalStack.addArrangedSubview(newRepsTextField)
        
        let newRepsLabel = UILabel()
        newRepsLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        newRepsLabel.text = "Reps"
        horizontalStack.addArrangedSubview(newRepsLabel)
        
        exerciseStackView.addArrangedSubview(horizontalStack)
        removeButton.isEnabled = true
    }
    
    func calculateTotalVolume() {
        var totalVolume: Int = 0
        
        for set in exerciseLogData!.set {
            let weight = Int(set.weight) ?? 0
            let reps = Int(set.reps) ?? 0
            
            totalVolume = totalVolume + (weight * reps)
        }
        volumeLabel.text = String(totalVolume) + weightUnitLabel.text!
    }
    
    func updatePercentage() {
        
        let exerciseTitle = titleLabel.text ?? ""
        let maxVolume = Int(maxInfoData![exerciseTitle]![Common.Define.routineBestMaxVolume]!) ?? 0
        
        var volumeText = volumeLabel.text!
        volumeText = String(volumeText[volumeText.startIndex..<volumeText.index(volumeText.endIndex, offsetBy: -2)])
        
        let currentVolume = Int(volumeText) ?? 0
        
        if currentVolume == 0 {
            bestVolumeImageView.isHidden = true
            volumeProportionLabel.isHidden = true
        } else {
            if maxVolume  <= currentVolume {
                bestVolumeImageView.isHidden = false
            } else {
                bestVolumeImageView.isHidden = true
            }
            volumeProportionLabel.isHidden = false
            if maxVolume > 0 {
                volumeProportionLabel.text = String(format: "(%d%%)", Int(100*(Float(currentVolume)/Float(maxVolume))))
            } else {
                volumeProportionLabel.text = ""
            }
        }
    }
        
    @IBAction func addButtonAction() {
        addStackView(weight: "", reps: "")
        
        presenter?.addSetAction(logDate: logDate!, exerciseTitle: titleLabel.text!)
    }
    
    @IBAction func removeButtonAction() {
        exerciseStackView.arrangedSubviews[exerciseStackView.arrangedSubviews.count-1].removeFromSuperview()
        if (exerciseStackView.arrangedSubviews.count == 1) {
            removeButton.isEnabled = false
        }
        presenter?.removeSetAction(logDate: logDate!, exerciseTitle: titleLabel.text!)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let tagString = String(format: "%02d", textField.tag)
        let text = textField.text
        
        presenter?.textfieldUpdated(tag: tagString, text: text!, logDate: logDate!, exerciseTitle: titleLabel.text!)
        
        return true
    }
}
