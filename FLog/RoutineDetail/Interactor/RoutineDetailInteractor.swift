//
//  RoutineDetailPresenter.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RoutineDetailInteractor: RoutineDetailInteractorInputProtocol {
    var presenter: ViperInteractorOutput?
    
    func loadData(with initialData: ViperEntity?) {
    }
    
    private func load(routine: MainRoutineModel) -> ViperEntity {
        let routineTitle = routine.title
            
        var dailyLogs = Array<DailyLogModel>()
        for arrayItem in UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)! {
            let dict: Dictionary<String, Any> = arrayItem as! Dictionary<String, Any>
            
            var exerciseLogs = Array<ExerciseLogModel>()
            for exerciseTitle in routine.exerciseTitles {
                let setArray: Array<Dictionary<String, String>> = dict[exerciseTitle] as! Array<Dictionary<String, String>>
                
                var sets = Array<SetModel>()
                for setDictionary in setArray {
                    sets.append(SetModel(weight: setDictionary[Common.Define.routineDetailWeight]!, reps: setDictionary[Common.Define.routineDetailReps]!))
                }
                exerciseLogs.append(ExerciseLogModel(exerciseTitle: exerciseTitle, set: sets))
            }
            dailyLogs.append(DailyLogModel(logDate: dict[Common.Define.routineDetailLogDate] as! String, exerciseLogs: exerciseLogs))
        }
        
        return RoutineDetailEntity(routine: routine, dailyLogs: dailyLogs)
    }
    
    func loadLogs(routine: MainRoutineModel) {
        if let _presenter = presenter as? RoutineDetailInteractorOutputProtocol {
            let routineTitle = routine.title
            
            if UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) == nil || UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)?.count == 0 {
                UserDefaults.standard.set([], forKey: routineTitle + Common.Define.routineDetail)
                _presenter.onError(title: "", message: "", buttonTitle: "", handler: nil)
            } else {
                _presenter.didLogLoaded(routineDetail: load(routine: routine))
            }
        }
    }
    
    func loadMaxInfo(routineTitle: String) {
        if let _presenter = presenter as? RoutineDetailInteractorOutputProtocol {
            _presenter.didMaxInfoLoaded(maxInfo: UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>)
        }
    }
    
    func updateMaxValueIfNeeded(routineTitle: String, logDate: String) {
        let routineArray = UserDefaults.standard.array(forKey: Common.Define.mainRoutine) as! Array<Dictionary<String, Any>>
        var exerciseTitles: Array<String>?
        
        for routineDict in routineArray {
            if routineDict[Common.Define.mainRoutineTitle] as! String == routineTitle {
                exerciseTitles = (routineDict[Common.Define.mainRoutineExercises] as! Array<String>)
            }
        }
        
        let logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == logDate {

                var newMaxInfoExists = false
                let maxInfo = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                
                for exerciseTitle in exerciseTitles! {
                    let exerciseArray = logArray[index][exerciseTitle] as! Array<Dictionary<String, String>>

                    var currentMaxWeight = 0
                    var currentVolume: Int = 0
                    for exerciseDict in exerciseArray {
                        let weight = Int(exerciseDict[Common.Define.routineDetailWeight] ?? "0") ?? 0
                        let reps = Int(exerciseDict[Common.Define.routineDetailReps] ?? "0") ?? 0
                        
                        currentVolume = currentVolume + (weight * reps)
                    }

                    for exerciseDict in exerciseArray {
                        let currentWeight = Int(exerciseDict[Common.Define.routineDetailWeight] ?? "0") ?? 0
                        
                        if currentMaxWeight < currentWeight {
                            currentMaxWeight = currentWeight
                        }
                    }
                    
                    if maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolumeDate] == logDate {
                        if maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume] != String(currentVolume){
                            newMaxInfoExists = true
                        }
                    } else {
                        if Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume]!) ?? 0 < currentVolume {
                            newMaxInfoExists = true
                        }
                    }
                    
                    if maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeightDate] == logDate {
                        if maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight] != String(currentMaxWeight) {
                            newMaxInfoExists = true
                        }
                    } else {
                        if Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0 < currentMaxWeight {
                            newMaxInfoExists = true
                        }
                    }

                    if (newMaxInfoExists) {
                        refindMaxValue(routineTitle: routineTitle, exerciseTitle: exerciseTitle)
                        break
                    }
                }
                break
            }
        }
    }
    
    func refindMaxValue(routineTitle: String, exerciseTitle: String) {
        var maxInfo = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
        let routineDetailArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!

        maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume] = "0"
        maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolumeDate] = ""
        maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight] = "0"
        maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeightDate] = ""
        
        for routineDetail in routineDetailArray {
            let date = (routineDetail as! Dictionary<String, Any>)[Common.Define.routineDetailLogDate] as! String

            var currentMaxWeight = 0
            var currentVolume = 0
            
            for detailedLog in (routineDetail as! Dictionary<String, Any>)[exerciseTitle] as! Array<Dictionary<String,String>> {
                let currentWeight = Int(detailedLog[Common.Define.routineDetailWeight]!) ?? 0
                let currentReps = Int(detailedLog[Common.Define.routineDetailReps]!) ?? 0
                currentVolume = currentVolume + (currentWeight*currentReps)
                
                if currentMaxWeight < currentWeight {
                    currentMaxWeight = currentWeight
                }
            }
            
            if Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume]!) ?? 0 < currentVolume {
                maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume] = String(currentVolume)
                maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolumeDate] = date
            }
            
            if Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0 < currentMaxWeight {
                maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight] = String(currentMaxWeight)
                maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeightDate] = date
            }
        }

        UserDefaults.standard.set(maxInfo, forKey: routineTitle + Common.Define.routineBest)
        self.loadMaxInfo(routineTitle: routineTitle)
    }
    
    func createLog(date: Date, routine: MainRoutineModel) {
        if let _presenter = presenter as? RoutineDetailInteractorOutputProtocol {
            let logDate = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            var logArray = UserDefaults.standard.array(forKey: routine.title + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
            
            for existingLogDict in logArray {
                if existingLogDict[Common.Define.routineDetailLogDate] as? String == logDate {
                    presenter?.onError(title: "Failed", message: "You've already created the log for\n", buttonTitle: "OK", handler: { (_) in
                    })
                    return
                }
            }
            
            var logDict: Dictionary<String, Any> = Dictionary<String, Any>()
            logDict[Common.Define.routineDetailLogDate] = logDate
            
            let exerciseTitles = routine.exerciseTitles
            for exerciseTitle in exerciseTitles {
                var exerciseDict: Dictionary<String, String> = Dictionary<String, String>()
                exerciseDict[Common.Define.routineDetailWeight] = ""
                exerciseDict[Common.Define.routineDetailReps] = ""
                logDict[exerciseTitle] = [exerciseDict]
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                do {
                    let managedOC = appDelegate.persistentContainer.viewContext
                    let request: NSFetchRequest<Timeline> = NSFetchRequest(entityName: String(describing: Timeline.self))
                    request.includesSubentities = false
                    let count = try managedOC.count(for: request)
                    
                    let entity = NSEntityDescription.entity(forEntityName: String(describing: Timeline.self ), in: managedOC)
                    let timeline = Timeline(entity: entity!, insertInto: managedOC)
                    timeline.id = Int32(count)
                    timeline.logDate = logDate
                    timeline.routineTitle = routine.title
                    try managedOC.save()
                } catch {
                }
            }
            
            logArray.append(logDict)
            UserDefaults.standard.set(logArray, forKey: routine.title + Common.Define.routineDetail)
            
            _presenter.didCreateLog()
        }
    }
    
    func removeLog(removeIndex: Int, routine: MainRoutineModel) {
        if let _presenter = presenter as? RoutineDetailInteractorOutputProtocol {
            let routineTitle = routine.title

            var array = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!
            let removedLog = array[removeIndex] as! Dictionary<String, Any>
            let removedLogDate = removedLog[Common.Define.routineDetailLogDate] as! String
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                do {
                    let managedOC = appDelegate.persistentContainer.viewContext
                    let request: NSFetchRequest<Timeline> = NSFetchRequest(entityName: String(describing: Timeline.self))
                    request.predicate = NSPredicate(format: "routineTitle == %@ AND logDate == %@", routineTitle, removedLogDate)
                    let timelineList = try managedOC.fetch(request)
                    for timeline in timelineList {
                        managedOC.delete(timeline)
                        try managedOC.save()
                    }
                } catch {
                }
            }
            
            array.remove(at: removeIndex)
            UserDefaults.standard.set(array, forKey: routineTitle + Common.Define.routineDetail)
            
            var newIndex = array.count - removeIndex
            newIndex = newIndex > array.count-1 ? array.count-1 : newIndex
            
            for exerciseTitle in routine.exerciseTitles {
                let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                let maxWeightDate = bestDict[exerciseTitle]![Common.Define.routineBestMaxWeightDate]
                let maxVolumeDate = bestDict[exerciseTitle]![Common.Define.routineBestMaxVolumeDate]

                if maxWeightDate == removedLogDate || maxVolumeDate == removedLogDate {
                    self.refindMaxValue(routineTitle: routineTitle, exerciseTitle: exerciseTitle)
                }
            }

            _presenter.didRemoveLog(removedIndex: newIndex)
        }
    }
    
    func createSet(routine: MainRoutineModel, logDate: String, exerciseTitle: String) {
        if let _presenter = presenter as? RoutineDetailInteractorOutputProtocol {
            let routineTitle = routine.title
            var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>

            for (index, logDict) in logArray.enumerated() {
                if logDict[Common.Define.mainRoutineTitle] as? String == logDate {
                    
                    var setArray = logDict[exerciseTitle] as! Array<Dictionary<String, String>>
                    var setDict = Dictionary<String, String>()
                    setDict[Common.Define.routineDetailWeight] = ""
                    setDict[Common.Define.routineDetailReps] = ""
                    setArray.append(setDict)
                    
                    logArray[index][exerciseTitle] = setArray
                    UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                    
                    break
                }
            }
            
            _presenter.didUpdateSetData(routineDetail: load(routine: routine))
        }
    }
    
    func removeSet(routine: MainRoutineModel, logDate: String, exerciseTitle: String) {
        if let _presenter = presenter as? RoutineDetailInteractorOutputProtocol {
            let routineTitle = routine.title
            var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>

            for (index, logDict) in logArray.enumerated() {
                if logDict[Common.Define.mainRoutineTitle] as? String == logDate {
                    var setArray = logDict[exerciseTitle] as! Array<Dictionary<String, String>>
                    if setArray.count <= 1 {
                        // does not allow the removal of a set when an exercise has the only set
                        return
                    }
                    
                    let lastWeight = Int(setArray.last![Common.Define.routineDetailWeight]!) ?? 0
                    var totalVolume: Int = 0
                    for setDict in setArray {
                        let weight = Int(setDict[Common.Define.routineDetailWeight] ?? "0") ?? 0
                        let reps = Int(setDict[Common.Define.routineDetailReps] ?? "0") ?? 0
                        
                        totalVolume = totalVolume + (weight * reps)
                    }
                    
                    setArray.removeLast()
                    logArray[index][exerciseTitle] = setArray
                    UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                    
                    let maxInfo = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                    let maxWeight = Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0
                    let maxVolume = Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume]!) ?? 0

                    if (totalVolume > 0 && maxVolume == totalVolume) || lastWeight > 0 && lastWeight == maxWeight {
                        refindMaxValue(routineTitle: routineTitle, exerciseTitle: exerciseTitle)
                    }
                    break
                }
            }
            
            _presenter.didUpdateSetData(routineDetail: load(routine: routine))
        }
    }
    
    func updateSet(routine: MainRoutineModel, setIndex: Int, slotIdentifier:Slot, text: String, logDate: String, exerciseTitle: String) {
        if let _presenter = presenter as? RoutineDetailInteractorOutputProtocol {
            let routineTitle = routine.title
            var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>

            for (index, logDict) in logArray.enumerated() {
                if logDict[Common.Define.mainRoutineTitle] as? String == logDate {
                    
                    var setArray = logDict[exerciseTitle] as! Array<Dictionary<String, String>>
                            
                    if slotIdentifier == .weight {
                        setArray[setIndex][Common.Define.routineDetailWeight] = text
                        logArray[index][exerciseTitle] = setArray
                        UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                    } else {
                        setArray[setIndex][Common.Define.routineDetailReps] = text
                        logArray[index][exerciseTitle] = setArray
                        UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                    }
                    break
                }
            }
            
            _presenter.didUpdateSetData(routineDetail: load(routine: routine))
        }
    }
}
