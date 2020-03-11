//
//  RoutineDetailPresenter.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation

class RoutineDetailInteractor: RoutineDetailInteractorInputProtocol {
    
    var presenter: RoutineDetailInteractorOutputProtocol?
    
    
    func loadLogs(routine: MainRoutineModel) {
        
        let routineTitle = routine.title
        
        if UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) == nil || UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)?.count == 0 {
            UserDefaults.standard.set([], forKey: routineTitle + Common.Define.routineDetail)
            presenter?.needsFirstLog()
        } else {
            
            var dailyExercises = Array<ExercisesOfDayModel>()
            for arrayItem in UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)! {
                let dict: Dictionary<String, Any> = arrayItem as! Dictionary<String, Any>
                
                var exercises = Array<ExerciseModel>()
                for exerciseTitle in routine.exerciseTitles {
                    let setArray: Array<Dictionary<String, String>> = dict[exerciseTitle] as! Array<Dictionary<String, String>>
                    
                    var sets = Array<SetModel>()
                    for setDictionary in setArray {
                        sets.append(SetModel(weight: setDictionary[Common.Define.routineDetailWeight]!, reps: setDictionary[Common.Define.routineDetailReps]!))
                    }
                    exercises.append(ExerciseModel(title: exerciseTitle, set: sets))
                }
                dailyExercises.append(ExercisesOfDayModel(timeStamp: dict[Common.Define.routineDetailDateSection] as! String, exercises: exercises))
            }
            presenter?.didLogLoaded(routineDetail: RoutineDetailModel(routine: routine, dailyExercises: dailyExercises))
        }
    }
    
    func loadMaxInfo(routineTitle: String) {
        presenter?.didMaxInfoLoaded(maxInfo: UserDefaults.standard.dictionary(forKey: routineTitle + Common.Define.routineBest) as! Dictionary<String, Dictionary<String, String>>)
    }
    
    
    func checkNewMaxInfo(routineTitle: String, timeStamp: String) {
        
        let logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == timeStamp {

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
                        maxInfo[exerciseTitle]![Common.Define.routineBestMaxVolumeDate] = timeStamp
                        newMaxInfoExists = true
                    }

                    if Int(maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight]!) ?? 0 < currentMaxWeight {
                        maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeight] = String(currentMaxWeight)
                        maxInfo[exerciseTitle]![Common.Define.routineBestMaxWeightDate] = timeStamp
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

        let timestamp = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        var logArray = UserDefaults.standard.array(forKey: routine.title + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        
        for existingLogDict in logArray {
            if existingLogDict[Common.Define.routineDetailDateSection] as? String == timestamp {
                presenter?.onError(title: "Failed", message: "You've already created the log for\n", buttonTitle: "OK", handler: { (_) in
                })
                return
            }
        }
        
        
        var logDict: Dictionary<String, Any> = Dictionary<String, Any>()
        logDict[Common.Define.routineDetailDateSection] = timestamp
        
        let exercises = routine.exerciseTitles
        for exercise in exercises {
            var exerciseDict: Dictionary<String, String> = Dictionary<String, String>()
            exerciseDict[Common.Define.routineDetailWeight] = ""
            exerciseDict[Common.Define.routineDetailReps] = ""
            logDict[exercise] = [exerciseDict]
        }
        
        logArray.append(logDict)
        UserDefaults.standard.set(logArray, forKey: routine.title + Common.Define.routineDetail)
        
        presenter?.didCreateNewFitnessLog()
    }
    
    func deleteFitnessLog(deleteIndex: Int, routine: MainRoutineModel) {
        let routineTitle = routine.title

        var array = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!
        let deletedLog = array[deleteIndex] as! Dictionary<String, String>
        let deletedTimeStamp = deletedLog[Common.Define.routineDetailDateSection]
        
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
            let date = (routineDetail as! Dictionary<String, Any>)[Common.Define.routineDetailDateSection] as! String

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
    
    func createNewSet(routineDetail: RoutineDetailModel, timeStamp: String, exerciseTitle: String) {
        
        let routineTitle = routineDetail.routine.title
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        var updatedRoutineDetail = RoutineDetailModel(routine: routineDetail.routine, dailyExercises: routineDetail.dailyExercises)

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == timeStamp {
                
                for (exerciseIndex, exercise) in updatedRoutineDetail.dailyExercises[index].exercises.enumerated() {
                    if exercise.title == exerciseTitle {

                        var exerciseArray = logArray[index][exerciseTitle] as! Array<Dictionary<String, String>>
                        var exerciseDict = Dictionary<String, String>()
                        exerciseDict[Common.Define.routineDetailWeight] = ""
                        exerciseDict[Common.Define.routineDetailReps] = ""
                        exerciseArray.append(exerciseDict)
                        
                        logArray[index][exerciseTitle] = exerciseArray
                        UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                        updatedRoutineDetail.dailyExercises[index].exercises[exerciseIndex].set.append(SetModel(weight: "", reps: ""))
                        break
                    }
                }
                break
            }
        }
        
        presenter?.didUpdateLog(routineDetail: updatedRoutineDetail)
    }
    
    func removeSet(routineDetail: RoutineDetailModel, timeStamp: String, exerciseTitle: String) {
        
        let routineTitle = routineDetail.routine.title
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        var updatedRoutineDetail = RoutineDetailModel(routine: routineDetail.routine, dailyExercises: routineDetail.dailyExercises)

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == timeStamp {
                
                for (exerciseIndex, exercise) in updatedRoutineDetail.dailyExercises[index].exercises.enumerated() {
                    if exercise.title == exerciseTitle {
                        
                        var exerciseArray = logArray[index][exerciseTitle] as! Array<Dictionary<String, String>>
                        
                        let lastWeight = Int(exerciseArray.last![Common.Define.routineDetailWeight]!) ?? 0
                        var totalVolume: Int = 0
                        for exerciseDict in exerciseArray {
                            let weight = Int(exerciseDict[Common.Define.routineDetailWeight] ?? "0") ?? 0
                            let reps = Int(exerciseDict[Common.Define.routineDetailReps] ?? "0") ?? 0
                            
                            totalVolume = totalVolume + (weight * reps)
                        }
                        
                        exerciseArray.removeLast()
                        logArray[index][exerciseTitle] = exerciseArray
                        UserDefaults.standard.set(logArray, forKey: routineTitle + Common.Define.routineDetail)
                        updatedRoutineDetail.dailyExercises[index].exercises[exerciseIndex].set.removeLast()
                        
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
    
    func updateSet(routineDetail: RoutineDetailModel, tag: String, text: String, timeStamp: String, exerciseTitle: String) {
        
        let routineTitle = routineDetail.routine.title
        var logArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail) as! Array<Dictionary<String, Any>>
        var updatedRoutineDetail = RoutineDetailModel(routine: routineDetail.routine, dailyExercises: routineDetail.dailyExercises)

        for (index, logDict) in logArray.enumerated() {
            if logDict[Common.Define.mainRoutineTitle] as? String == timeStamp {
                
                for (exerciseIndex, exercise) in updatedRoutineDetail.dailyExercises[index].exercises.enumerated() {
                    if exercise.title == exerciseTitle {

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
                            updatedRoutineDetail.dailyExercises[index].exercises[exerciseIndex].set[setIndex].weight = text
                            
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
                            updatedRoutineDetail.dailyExercises[index].exercises[exerciseIndex].set[setIndex].reps = text
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