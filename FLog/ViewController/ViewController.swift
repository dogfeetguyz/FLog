//
//  ViewController.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if UserDefaults.standard.value(forKey: Common.Define.mainRoutine) == nil {
            
            // main routine array structure
            UserDefaults.standard.set([[Common.Define.mainRoutineTitle:"Leg Day(Sample)", Common.Define.mainRoutineUnit:Common.Define.mainRoutineUnitKg, Common.Define.mainRoutineExercises:["Back Squat", "Split Squat", "Walking Lunge", "Sled Push"]]], forKey: Common.Define.mainRoutine)
            var oneweekago = Date()
            oneweekago.addTimeInterval(-(60*60*24*7))
            var twoweeksago = Date()
            twoweeksago.addTimeInterval(-(60*60*24*14))
            
            // detail array structure
            UserDefaults.standard.set([[Common.Define.mainRoutineTitle:DateFormatter.localizedString(from: twoweeksago, dateStyle: .medium, timeStyle: .none),
                                        "Back Squat":[[Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"], [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"], [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"], [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"], [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"10"]],
                                        "Split Squat":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"12"]],
                                        "Walking Lunge":[[Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"15"]],
                                        "Sled Push":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"]] ],
                                        [Common.Define.mainRoutineTitle:DateFormatter.localizedString(from: oneweekago, dateStyle: .medium, timeStyle: .none),
                                        "Back Squat":[[Common.Define.routineDetailWeight:"140", Common.Define.routineDetailReps:"6"], [Common.Define.routineDetailWeight:"145", Common.Define.routineDetailReps:"5"], [Common.Define.routineDetailWeight:"150", Common.Define.routineDetailReps:"5"], [Common.Define.routineDetailWeight:"155", Common.Define.routineDetailReps:"4"], [Common.Define.routineDetailWeight:"160", Common.Define.routineDetailReps:"2"]],
                                        "Split Squat":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"95", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"95", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"100", Common.Define.routineDetailReps:"7"]],
                                        "Walking Lunge":[[Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"10"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"10"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"10"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"], [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"7"]],
                                        "Sled Push":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"], [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"]] ]],
                                      forKey: "Leg Day(Sample)_detail")
            
            // best array structure
//            UserDefaults.standard.set(["Back Squat":[Common.Define.mainRoutineUnit:Common.Define.mainRoutineUnitKg, Common.Define.routineBestMaxVolume:"", Common.Define.routineBestMaxVolumeDate:"", Common.Define.routineBestMaxWeight:"", Common.Define.routineBestMaxWeightDate:""],
//                                        "Split Squat":[Common.Define.mainRoutineUnit:Common.Define.mainRoutineUnitKg, Common.Define.routineBestMaxVolume:"", Common.Define.routineBestMaxVolumeDate:"", Common.Define.routineBestMaxWeight:"", Common.Define.routineBestMaxWeightDate:""],
//                                        "Walking Lunge":[Common.Define.mainRoutineUnit:Common.Define.mainRoutineUnitKg, Common.Define.routineBestMaxVolume:"", Common.Define.routineBestMaxVolumeDate:"", Common.Define.routineBestMaxWeight:"", Common.Define.routineBestMaxWeightDate:""],
//                                        "Sled Push":[Common.Define.mainRoutineUnit:Common.Define.mainRoutineUnitKg, Common.Define.routineBestMaxVolume:"", Common.Define.routineBestMaxVolumeDate:"", Common.Define.routineBestMaxWeight:"", Common.Define.routineBestMaxWeightDate:""] ],
//                                      forKey: "Leg(Sample)_best" )
        }

        
        if !UserDefaults.standard.bool(forKey: Common.Define.checkBestCreatedBefore) {
            UserDefaults.standard.set(true, forKey: Common.Define.checkBestCreatedBefore)
            
            let mainRoutine = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)!
            for dict in mainRoutine {
                let routineDict = dict as! Dictionary<String, Any>
                let routineTitle = routineDict[Common.Define.mainRoutineTitle] as! String
                let routineUnit = routineDict[Common.Define.mainRoutineUnit] as! String
                let exercises = routineDict[Common.Define.mainRoutineExercises] as! Array<String>

                var bestDict = Dictionary<String, Dictionary<String, String>>()
                for exercise in exercises {
                    bestDict[exercise] = Dictionary<String, String>()
                    bestDict[exercise]![Common.Define.mainRoutineUnit] = routineUnit
                    bestDict[exercise]![Common.Define.routineBestMaxVolume] = "0"
                    bestDict[exercise]![Common.Define.routineBestMaxVolumeDate] = ""
                    bestDict[exercise]![Common.Define.routineBestMaxWeight] = "0"
                    bestDict[exercise]![Common.Define.routineBestMaxWeightDate] = ""
                
                }
                
                if UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) == nil {
                    continue
                }
                
                let routineDetailArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!
                
                for routineDetail in routineDetailArray {
                    let date = (routineDetail as! Dictionary<String, Any>)[Common.Define.mainRoutineTitle] as! String
                    for exercise in exercises {
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
                }
                
                UserDefaults.standard.set(bestDict, forKey: routineTitle + Common.Define.routineBest)
            }
        }
        
        
        let image: UIImage = UIImage(named: "fitlog.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        logoView.addSubview(imageView)
        
        self.navigationItem.titleView = logoView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.array(forKey: Common.Define.mainRoutine)!.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            Common.View.showAlertWithTwoButtons(viewController: self, title: "Delete the routine?", message: "", cancelButtonTitle: "Cancel", OKButtonTitle: "Delete", OKHandler: { (_) in
                var routineArray = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)
                let deleteIndex = indexPath.row
                
                let data: Dictionary<String, Any> = routineArray?[deleteIndex] as! Dictionary<String, Any>
                let title: String = data[Common.Define.mainRoutineTitle] as! String
                UserDefaults.standard.removeObject(forKey: title + Common.Define.routineDetail)
                
                routineArray?.remove(at: deleteIndex)
                UserDefaults.standard.set(routineArray, forKey: Common.Define.mainRoutine)
                
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var routines = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)!
        let item = routines[sourceIndexPath.row]
        routines.remove(at: sourceIndexPath.row)
        routines.insert(item, at: destinationIndexPath.row)
        
        UserDefaults.standard.set(routines, forKey: Common.Define.mainRoutine)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        let data: Dictionary<String, Any> = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)?[indexPath.row] as! Dictionary<String, Any>
        
        
        let exercises = data[Common.Define.mainRoutineExercises] as! Array<String>
        let exercise: String = exercises.joined(separator: "\n")
        cell.contentLabel.numberOfLines = exercises.count
        
        cell.titleLabel?.text = data[Common.Define.mainRoutineTitle] as? String

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attrString = NSMutableAttributedString(string: exercise)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        cell.editButton.tag = indexPath.row
        cell.contentLabel?.attributedText = attrString
        
        cell.editButton.isHidden = !tableView.isEditing
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "RoutineDetailViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! RoutineDetailViewController
        viewController.routineDictionary = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)?[indexPath.row] as? Dictionary<String, Any>
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func newButtonAction() {
        
        let storyboard = UIStoryboard(name: "NewGroupViewController", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func editButtonAction() {
        
        if editButton.titleLabel?.text == "Edit" {
            editButton.setTitle("Done", for: .normal)
            tableView.setEditing(true, animated: true)
            newButton.isHidden = true
        } else {
            editButton.setTitle("Edit", for: .normal)
            tableView.setEditing(false, animated: true)
            newButton.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func editCellButtonAction(button: UIButton) {
        let index = button.tag
        var routines = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)!
        var item = routines[index] as! Dictionary<String, Any>
        let originalTitle = item[Common.Define.mainRoutineTitle] as? String
        
        let alert = UIAlertController(title: "Rename", message: "Enter a new name", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = originalTitle
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let newTitle = textField?.text
            item[Common.Define.mainRoutineTitle] = newTitle
            routines.remove(at: index)
            routines.insert(item, at: index)
            UserDefaults.standard.set(routines, forKey: Common.Define.mainRoutine)
            
            
            let detailArray = UserDefaults.standard.array(forKey: originalTitle! + Common.Define.routineDetail)
            let bestDictionary = UserDefaults.standard.dictionary(forKey: originalTitle! + Common.Define.routineBest)
            
            UserDefaults.standard.removeObject(forKey: originalTitle! + Common.Define.routineDetail)
            UserDefaults.standard.removeObject(forKey: originalTitle! + Common.Define.routineBest)
            
            UserDefaults.standard.set(detailArray, forKey: newTitle! + Common.Define.routineDetail)
            UserDefaults.standard.set(bestDictionary, forKey: newTitle! + Common.Define.routineBest)
            
            self.tableView.reloadData()
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

