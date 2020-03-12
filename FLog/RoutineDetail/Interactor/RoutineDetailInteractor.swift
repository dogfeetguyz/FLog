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
    
    var presenter: RoutineDetailInteractorOutputProtocol?
    
    
    func loadLogs(routine: MainRoutineModel) {
        
        let routineTitle = routine.title
        
        if UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) == nil || UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)?.count == 0 {
            UserDefaults.standard.set([], forKey: routineTitle + Common.Define.routineDetail)
            presenter?.needsFirstLog()
        } else {
            
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
            presenter?.didLogLoaded(routineDetail: RoutineDetailModel(routine: routine, dailyLogs: dailyLogs))
        }
    }
    
    func loadMaxInfo(routineTitle: String) {
        presenter?.didMaxInfoLoaded(maxInfo: UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>)
    }
    
    
    func checkNewMaxInfo(routineTitle: String, logDate: String) {
        
        let logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == logDate {

                var newMaxInfoExists = false
                var maxInfo = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                
                for exerciseTitle in logArray[index].keys {
                    if exerciseTitle == "title" {
                        continue
                    }
                    
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

                    
                    if Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume]!) ?? 0 < currentVolume {
                        maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume] = String(currentVolume)
                        maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolumeDate] = logDate
                        newMaxInfoExists = true
                    }

                    if Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0 < currentMaxWeight {
                        maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight] = String(currentMaxWeight)
                        maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeightDate] = logDate
                        newMaxInfoExists = true
                    }
                }

                if (newMaxInfoExists) {
                    UserDefaults.standard.set(maxInfo, forKey: routineTitle + Common.Define.routineBest)
                    presenter?.didMaxInfoLoaded(maxInfo: maxInfo)
                }
                break
            }
        }
    }
    
    func createNewFitnessLog(date: Date, routine: MainRoutineModel) {

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
        
        presenter?.didCreateNewFitnessLog()
    }
    
    func deleteFitnessLog(deleteIndex: Int, routine: MainRoutineModel) {
        let routineTitle = routine.title

        var array = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!
        let deletedLog = array[deleteIndex] as! Dictionary<String, Any>
        let deletedTimeStamp = deletedLog[Common.Define.routineDetailLogDate] as! String
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                let managedOC = appDelegate.persistentContainer.viewContext
                let request: NSFetchRequest<Timeline> = NSFetchRequest(entityName: String(describing: Timeline.self))
                request.predicate = NSPredicate(format: "routineTitle == %@ AND logDate == %@", routineTitle, deletedTimeStamp)
                let timelineList = try managedOC.fetch(request)
                for timeline in timelineList {
                    managedOC.delete(timeline)
                    try managedOC.save()
                }
            } catch {
            }
        }
        
        array.remove(at: deleteIndex)
        UserDefaults.standard.set(array, forKey: routineTitle + Common.Define.routineDetail)
        
        var newIndex = array.count - deleteIndex
        newIndex = newIndex > array.count-1 ? array.count-1 : newIndex
        
        for exerciseTitle in routine.exerciseTitles {
            let bestDict = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
            let maxWeightDate = bestDict[exerciseTitle]![Common.Define.routineBestMaxWeightDate]
            let maxVolumeDate = bestDict[exerciseTitle]![Common.Define.routineBestMaxVolumeDate]

            if maxWeightDate == deletedTimeStamp || maxVolumeDate == deletedTimeStamp {
                self.refindMaxValue(routineTitle: routineTitle, exerciseTitle: exerciseTitle)
            }
        }
        
        if array.count == 0 {
            presenter?.needsFirstLog()
        } else {
            presenter?.didDeleteFitnessLog(deletedIndex: newIndex)
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
    
    func createNewSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String) {
        
        let routineTitle = routineDetail.routine.title
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        var updatedRoutineDetail = RoutineDetailModel(routine: routineDetail.routine, dailyLogs: routineDetail.dailyLogs)

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == logDate {
                
                for (logIndex, log) in updatedRoutineDetail.dailyLogs[index].exerciseLogs.enumerated() {
                    if log.exerciseTitle == exerciseTitle {

                        var setArray = logArray[index][exerciseTitle] as! Array<Dictionary<String, String>>
                        var setDict = Dictionary<String, String>()
                        setDict[Common.Define.routineDetailWeight] = ""
                        setDict[Common.Define.routineDetailReps] = ""
                        setArray.append(setDict)
                        
                        logArray[index][exerciseTitle] = setArray
                        UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                        updatedRoutineDetail.dailyLogs[index].exerciseLogs[logIndex].set.append(SetModel(weight: "", reps: ""))
                        break
                    }
                }
                break
            }
        }
        
        presenter?.didUpdateLog(routineDetail: updatedRoutineDetail)
    }
    
    func removeSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String) {
        
        let routineTitle = routineDetail.routine.title
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        var updatedRoutineDetail = RoutineDetailModel(routine: routineDetail.routine, dailyLogs: routineDetail.dailyLogs)

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == logDate {
                
                for (logIndex, log) in updatedRoutineDetail.dailyLogs[index].exerciseLogs.enumerated() {
                    if log.exerciseTitle == exerciseTitle {
                        
                        var setArray = logArray[index][exerciseTitle] as! Array<Dictionary<String, String>>
                        
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
                        updatedRoutineDetail.dailyLogs[index].exerciseLogs[logIndex].set.removeLast()
                        
                        let maxInfo = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                        let maxWeight = Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0
                        let maxVolume = Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolume]!) ?? 0

                        if (totalVolume > 0 && maxVolume == totalVolume) || lastWeight > 0 && lastWeight == maxWeight {
                            refindMaxValue(routineTitle: routineTitle, exerciseTitle: exerciseTitle)
                        }
                        break
                    }
                }
                break
            }
        }
        
        presenter?.didUpdateLog(routineDetail: updatedRoutineDetail)
    }
    
    func updateSet(routineDetail: RoutineDetailModel, tag: String, text: String, logDate: String, exerciseTitle: String) {
        
        let routineTitle = routineDetail.routine.title
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        var updatedRoutineDetail = RoutineDetailModel(routine: routineDetail.routine, dailyLogs: routineDetail.dailyLogs)

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == logDate {
                
                for (logIndex, log) in updatedRoutineDetail.dailyLogs[index].exerciseLogs.enumerated() {
                    if log.exerciseTitle == exerciseTitle {

                        let setIndex = Int(tag[tag.startIndex..<tag.index(before: tag.endIndex)]) ?? 0
                        let identifier = Int(String(tag[tag.index(before: tag.endIndex)])) ?? 0
                        var exerciseArray = logArray[index][exerciseTitle] as! Array<Dictionary<String, String>>
                        
                        if identifier == 0 {
                            let maxInfo = UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>
                            let maxWeight = Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0
                            let currentWeight = Int(exerciseArray[setIndex][Common.Define.routineDetailWeight]!) ?? 0

                            exerciseArray[setIndex][Common.Define.routineDetailWeight] = text
                            logArray[index][exerciseTitle] = exerciseArray
                            UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                            updatedRoutineDetail.dailyLogs[index].exerciseLogs[logIndex].set[setIndex].weight = text
                            
                            if (maxWeight == currentWeight) {
                                let newWeight = Int(text) ?? 00
                                if (currentWeight > newWeight) {
                                    refindMaxValue(routineTitle: routineTitle, exerciseTitle: exerciseTitle)
                                }
                            }
                        } else {
                            exerciseArray[setIndex][Common.Define.routineDetailReps] = text
                            logArray[index][exerciseTitle] = exerciseArray
                            UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                            updatedRoutineDetail.dailyLogs[index].exerciseLogs[logIndex].set[setIndex].reps = text
                        }
                        
                        break
                    }
                }
                break
            }
        }
        
        presenter?.didUpdateLog(routineDetail: updatedRoutineDetail)
    }
}
