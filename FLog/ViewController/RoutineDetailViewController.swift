//
//  RoutineDetailViewController.swift
//  FLog
//
//  Created by Yejun Park on 17/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import DatePickerDialog

class RoutineDetailViewController: KUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var personalRecordStackView: UIStackView!
    @IBOutlet weak var moreButton: UIButton!
    
    var routineDictionary: Dictionary<String, Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let routineTitle = routineDictionary[Common.Define.mainRoutineTitle] as! String
        self.title = routineTitle
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        
        if UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) == nil || UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)?.count == 0 {
            UserDefaults.standard.set([], forKey: routineTitle + Common.Define.routineDetail)
            createFirstLog()
        } else {
            for arrayItem in UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)! {
                let dict: Dictionary<String, Any> = arrayItem as! Dictionary<String, Any>
                segmentedControl.insertSegment(withTitle: dict[Common.Define.mainRoutineTitle] as! String, at: 0)
            }
            
            segmentedControl.selectedSegmentIndex = 0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateBestView), name: Notification.Name(Common.Define.notificationPersonalRecordUpdated), object: nil)
        updateBestView()
    }
    
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Common.Define.notificationPersonalRecordUpdated), object: nil)
    }
    
    @objc func updateBestView() {
        var firstItem = true
        for subview in personalRecordStackView.arrangedSubviews {
            if firstItem {
                firstItem = false
                continue
            }
            subview.removeFromSuperview()
        }
        
        if (moreButton.attributedTitle(for: .normal)?.string == "less") {

            let routineTitle = routineDictionary[Common.Define.mainRoutineTitle] as! String
            let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
            for exercise in (routineDictionary[Common.Define.mainRoutineExercises] as! Array<String>) {
                let text1 = exercise

                let unit = bestDict[exercise]![Common.Define.mainRoutineUnit]!
                let bestMaxVolume = bestDict[exercise]![Common.Define.routineBestMaxVolume]!
                let bestMaxVolumeDate = bestDict[exercise]![Common.Define.routineBestMaxVolumeDate]!
                let bestMaxWeight = bestDict[exercise]![Common.Define.routineBestMaxWeight]!
                let bestMaxWeightDate = bestDict[exercise]![Common.Define.routineBestMaxWeightDate]!
                let text2 = String(format: "Max Volume: %@%@ (%@)\nMax Weight: %@%@ (%@)", bestMaxVolume, unit, bestMaxVolumeDate, bestMaxWeight, unit, bestMaxWeightDate)

                let text = text1 + "\n" + text2 as NSString
                let nameLabel = UILabel()
                nameLabel.numberOfLines = 3
                let attributedString = NSMutableAttributedString(string: text as String)
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: text1))
                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: (text as NSString).range(of: text2))
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: (text as NSString).range(of: text1))
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: (text as NSString).range(of: text2))


                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, text.length))

                nameLabel.attributedText = attributedString
                personalRecordStackView.addArrangedSubview(nameLabel)
            }
        }
    }
    
    @discardableResult func newFitnessLog(timestamp: String) -> String {
        let routineTitle = routineDictionary[Common.Define.mainRoutineTitle] as! String
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        
        for existingLogDict in logArray {
            if existingLogDict[Common.Define.mainRoutineTitle] as? String == timestamp {

                Common.View.showAlertWithOneButton(viewController: self, title: "Failed", message: "You've already created the log for\n" + timestamp, buttonTitle: "OK", handler: { (_) in
                })
                return ""
            }
        }
        
        
        var logDict: Dictionary<String, Any> = Dictionary<String, Any>()
        logDict[Common.Define.mainRoutineTitle] = timestamp
        
        let exercises = (routineDictionary[Common.Define.mainRoutineExercises] as! Array<String>)
        for exercise in exercises {
            var exerciseDict: Dictionary<String, String> = Dictionary<String, String>()
            exerciseDict[Common.Define.routineDetailWeight] = ""
            exerciseDict[Common.Define.routineDetailReps] = ""
            logDict[exercise] = [exerciseDict]
        }
        
        logArray.append(logDict)
        UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
        
        return timestamp
    }
    
    func createFirstLog() {
        tableView.isHidden = true
        DatePickerDialog().show("Choose a date", maximumDate:Date(), datePickerMode: .date) { (date) in
            if date == nil {
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)

                let title: String = self.newFitnessLog(timestamp: timestamp)
                self.segmentedControl.insertSegment(withTitle: title, at: 0)
                self.segmentedControl.selectedSegmentIndex = 0
            } else {
                let timestamp = DateFormatter.localizedString(from: date!, dateStyle: .medium, timeStyle: .none)

                let title: String = self.newFitnessLog(timestamp: timestamp)
                self.segmentedControl.insertSegment(withTitle: title, at: 0)
                self.segmentedControl.selectedSegmentIndex = 0
            }
            
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func refindMaxValue(exercise: String) {     // when max data deleted, find new max data
        let routineTitle = self.routineDictionary[Common.Define.mainRoutineTitle] as! String
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
    
    @IBAction func newButtonAction() {
        DatePickerDialog().show("Choose a date", datePickerMode: .date) { (date) in
            if date == nil {
                return
            }
            
            let timestamp = DateFormatter.localizedString(from: date!, dateStyle: .medium, timeStyle: .none)

            let title: String = self.newFitnessLog(timestamp: timestamp)
            if title.count > 0 {
                self.segmentedControl.insertSegment(withTitle: title, at: 0)
                self.segmentedControl.selectedSegmentIndex = 0
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func deleteButtonAction() {
        
        Common.View.showAlertWithTwoButtons(viewController: self, title: "Delete the fitness log?", message: "", cancelButtonTitle: "Cancel", OKButtonTitle: "Delete", OKHandler: { (_) in
            let deleteIndex = self.segmentedControl.numberOfSegments - 1 - self.segmentedControl.selectedSegmentIndex
            let dateRemoved = self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)
            let routineTitle = self.routineDictionary[Common.Define.mainRoutineTitle] as! String

            var array = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!
            array.remove(at: deleteIndex)
            UserDefaults.standard.set(array, forKey: routineTitle + Common.Define.routineDetail)
            
            var newIndex = self.segmentedControl.selectedSegmentIndex
            newIndex = newIndex > self.segmentedControl.numberOfSegments-1 ? self.segmentedControl.numberOfSegments-1 : newIndex
            self.segmentedControl.removeSegment(at: self.segmentedControl.selectedSegmentIndex)
            self.segmentedControl.selectedSegmentIndex = newIndex
            
            for exercise in (self.routineDictionary[Common.Define.mainRoutineExercises] as! Array<String>) {
                let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                let maxWeightDate = bestDict[exercise]![Common.Define.routineBestMaxWeightDate]
                let maxVolumeDate = bestDict[exercise]![Common.Define.routineBestMaxVolumeDate]
                
                if maxWeightDate == dateRemoved || maxVolumeDate == dateRemoved {
                    self.refindMaxValue(exercise: exercise)
                }
            }
            
            if (self.segmentedControl.numberOfSegments) == 0 {
                self.createFirstLog()
            } else {
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func moreButtonAction() {
        if (moreButton.attributedTitle(for: .normal)?.string == "more") {
            moreButton.setAttributedTitle(NSAttributedString(string: "less", attributes: [NSAttributedString.Key.foregroundColor:UIColor.link]), for: .normal)
            moreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        } else {
            moreButton.setTitle("more", for: .normal)
            moreButton.setAttributedTitle(NSAttributedString(string: "more", attributes: [NSAttributedString.Key.foregroundColor:UIColor.link]), for: .normal)
            moreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        updateBestView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (routineDictionary[Common.Define.mainRoutineExercises] as! Array<String>).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineDetailTableViewCell", for: indexPath) as! RoutineDetailTableViewCell
        let exerciseTitle: String = (routineDictionary[Common.Define.mainRoutineExercises] as! Array<String>)[indexPath.row]
        
        cell.tableView = tableView
        cell.titleLabel?.text = exerciseTitle
        cell.weightUnitLabel?.text = routineDictionary[Common.Define.mainRoutineUnit] as? String
        cell.addButton.addTarget(cell, action: #selector(cell.addButtonAction), for: .touchUpInside)
        cell.removeButton.addTarget(cell, action: #selector(cell.removeButtonAction), for: .touchUpInside)
        
        let routineTitle = routineDictionary[Common.Define.mainRoutineTitle] as! String
        let logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!
        if logArray.count > 0 {
            let currentIndex = self.segmentedControl.numberOfSegments - 1 - self.segmentedControl.selectedSegmentIndex
            let logDict = logArray[currentIndex] as! Dictionary<String, Any>
            
            cell.exerciseArray = logDict[exerciseTitle] as? Array<Dictionary<String, String>>
            cell.exerciseLogDate = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
            cell.routineTitle = routineDictionary[Common.Define.mainRoutineTitle] as? String
            
            cell.buildStackView()
        }
        
        return cell
    }
       
    @IBAction func segmentSelected(sender:ScrollableSegmentedControl) {
        tableView.reloadData()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        super.keyboardWillHide(sender: sender)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
