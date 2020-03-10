//
//  MainTableViewCell.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineDetailTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var tableView: UITableView!
    var exerciseArray: Array<Dictionary<String, String>>!
    var exerciseLogDate: String!
    var routineTitle: String!
    
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
        checkMaxValue()
        updatePercentage()

        resetStackView()
        var firstItem = true
        for exerciseDict in exerciseArray {
            if firstItem {
                firstItem = false
                weightTextField.text = exerciseDict[Common.Define.routineDetailWeight]
                repsTextField.text = exerciseDict[Common.Define.routineDetailReps]
                
                let currentWeight = Int(exerciseDict[Common.Define.routineDetailWeight]!) ?? 0
                let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                let exercise = titleLabel.text ?? ""
                let maxWeight = Int(bestDict[exercise]![Common.Define.routineBestMaxWeight]!) ?? 0
                
                if (currentWeight > 0 && currentWeight >= maxWeight) {
                    bestWeightImageView.isHidden = false
                } else if (maxWeight > 0) {
                    proportionLabel.isHidden = false
                    proportionLabel.text = String(format: "%d%%", Int(100*(Float(currentWeight)/Float(maxWeight))))
                }
                
            } else {
                addStackView(weight: exerciseDict[Common.Define.routineDetailWeight] ?? "", reps: exerciseDict[Common.Define.routineDetailReps] ?? "")
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
        let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
        let exercise = titleLabel.text ?? ""
        let maxWeight = Int(bestDict[exercise]![Common.Define.routineBestMaxWeight]!) ?? 0
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
    
    @IBAction func addButtonAction() {
        
        var exerciseDict = Dictionary<String, String>()
        exerciseDict[Common.Define.routineDetailWeight] = ""
        exerciseDict[Common.Define.routineDetailReps] = ""
        exerciseArray.append(exerciseDict)
        updateSet()
        
        addStackView(weight: "", reps: "")
        tableView.reloadData()
    }
    
    
     func updateSet() {
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        
        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == exerciseLogDate {
                let exerciseTitle = titleLabel.text ?? ""
                
                logArray[index][exerciseTitle] = exerciseArray
                break
            }
        }
        
        UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
    }
    
    func calculateTotalVolume() {
        var totalVolume: Int = 0
        
        for exerciseDict in exerciseArray {
            let weight = Int(exerciseDict[Common.Define.routineDetailWeight] ?? "0") ?? 0
            let reps = Int(exerciseDict[Common.Define.routineDetailReps] ?? "0") ?? 0
            
            totalVolume = totalVolume + (weight * reps)
            volumeLabel.text = String(totalVolume) + weightUnitLabel.text!
        }
    }
    
    func updatePercentage() {
        
        let exercise = titleLabel.text ?? ""
        let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
        let maxVolume = Int(bestDict[exercise]![Common.Define.routineBestMaxVolume]!) ?? 0
        
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
            volumeProportionLabel.text = String(format: "(%d%%)", Int(100*(Float(currentVolume)/Float(maxVolume))))
        }
    }
    
    func checkMaxValue() { // when data added, check if it is max
        let exercise = titleLabel.text ?? ""
        var volumeText = volumeLabel.text!
        volumeText = String(volumeText[volumeText.startIndex..<volumeText.index(volumeText.endIndex, offsetBy: -2)])
        
        let currentVolume = Int(volumeText) ?? 0
        var currentMaxWeight = 0
        
        for exerciseDict in exerciseArray {
            let currentWeight = Int(exerciseDict[Common.Define.routineDetailWeight] ?? "0") ?? 0
            
            if currentMaxWeight < currentWeight {
                currentMaxWeight = currentWeight
            }
        }
        
        var updated = false
        var bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
        if Int(bestDict[exercise]![Common.Define.routineBestMaxVolume]!) ?? 0 < currentVolume {
            bestDict[exercise]![Common.Define.routineBestMaxVolume] = String(currentVolume)
            bestDict[exercise]![Common.Define.routineBestMaxVolumeDate] = exerciseLogDate
            updated = true
        }

        if Int(bestDict[exercise]![Common.Define.routineBestMaxWeight]!) ?? 0 < currentMaxWeight {
            bestDict[exercise]![Common.Define.routineBestMaxWeight] = String(currentMaxWeight)
            bestDict[exercise]![Common.Define.routineBestMaxWeightDate] = exerciseLogDate
            updated = true
        }

        if (updated) {
            UserDefaults.standard.set(bestDict, forKey: routineTitle + Common.Define.routineBest)
            NotificationCenter.default.post(name: Notification.Name(Common.Define.notificationPersonalRecordUpdated), object: nil)
        }
    }
    
    func refindMaxValue() {     // when max data deleted, find max data again
        let exercise = titleLabel.text ?? ""
        var bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
        let routineDetailArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!

        bestDict[exercise]![Common.Define.routineBestMaxVolume] = "0"
        bestDict[exercise]![Common.Define.routineBestMaxVolumeDate] = ""
        bestDict[exercise]![Common.Define.routineBestMaxWeight] = "0"
        bestDict[exercise]![Common.Define.routineBestMaxWeightDate] = ""
        
        for routineDetail in routineDetailArray {
            let date = (routineDetail as! Dictionary<String, Any>)[Common.Define.mainRoutineTitle] as! String

            var currentMaxWeight = 0
            var currentVolume = 0
            
            for detailedLog in (routineDetail as! Dictionary<String, Any>)[exercise] as! Array<Dictionary<String,String>> {
                let currentWeight = Int(detailedLog[Common.Define.routineDetailWeight]!) ?? 0
                let currentReps = Int(detailedLog[Common.Define.routineDetailReps]!) ?? 0
                currentVolume = currentVolume + (currentWeight*currentReps)
                
                if currentMaxWeight < currentWeight {
                    currentMaxWeight = currentWeight
                }
            }
            
            if Int(bestDict[exercise]![Common.Define.routineBestMaxVolume]!) ?? 0 < currentVolume {
                bestDict[exercise]![Common.Define.routineBestMaxVolume] = String(currentVolume)
                bestDict[exercise]![Common.Define.routineBestMaxVolumeDate] = date
            }
            
            if Int(bestDict[exercise]![Common.Define.routineBestMaxWeight]!) ?? 0 < currentMaxWeight {
                bestDict[exercise]![Common.Define.routineBestMaxWeight] = String(currentMaxWeight)
                bestDict[exercise]![Common.Define.routineBestMaxWeightDate] = date
            }
        }

        UserDefaults.standard.set(bestDict, forKey: routineTitle + Common.Define.routineBest)
        NotificationCenter.default.post(name: Notification.Name(Common.Define.notificationPersonalRecordUpdated), object: nil)
    }
    
    @IBAction func removeButtonAction() {
        
        let exercise = titleLabel.text ?? ""
        let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
        let lastWeight = Int(exerciseArray.last![Common.Define.routineDetailWeight]!) ?? 0
        
        exerciseArray.removeLast()
        updateSet()
        
        
        let maxWeight = Int(bestDict[exercise]![Common.Define.routineBestMaxWeight]!) ?? 0
        let maxVolume = Int(bestDict[exercise]![Common.Define.routineBestMaxVolume]!) ?? 0
        var volumeText = volumeLabel.text!
        volumeText = String(volumeText[volumeText.startIndex..<volumeText.index(volumeText.endIndex, offsetBy: -2)])

        let currentVolume = Int(volumeText) ?? 0
        
        if (currentVolume > 0 && maxVolume == currentVolume) ||
            lastWeight > 0 && lastWeight == maxWeight {
            refindMaxValue()
        }
        
        exerciseStackView.arrangedSubviews[exerciseStackView.arrangedSubviews.count-1].removeFromSuperview()
        if (exerciseStackView.arrangedSubviews.count == 1) {
            removeButton.isEnabled = false
        }
        tableView.reloadData()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let tagString = String(format: "%02d", textField.tag)

        let index = Int(tagString[tagString.startIndex..<tagString.index(before: tagString.endIndex)]) ?? 0
        let identifier = Int(String(tagString[tagString.index(before: tagString.endIndex)])) ?? 0
        
        if (identifier == 0) {
            let exercise = titleLabel.text ?? ""
            let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
            let maxWeight = Int(bestDict[exercise]![Common.Define.routineBestMaxWeight]!) ?? 0
            let currentWeight = Int(exerciseArray[index][Common.Define.routineDetailWeight]!) ?? 0

            exerciseArray[index][identifier == 0 ? Common.Define.routineDetailWeight : Common.Define.routineDetailReps] = textField.text
            updateSet()
            
            if (maxWeight == currentWeight) {
                let newWeight = Int(textField.text!) ?? 00
                if (currentWeight > newWeight) {
                    refindMaxValue()
                }
            }
        } else {
            exerciseArray[index][identifier == 0 ? Common.Define.routineDetailWeight : Common.Define.routineDetailReps] = textField.text
            updateSet()
        }
        
        return true
    }
}
