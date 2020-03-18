//
//  FLogInteractor.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class FLogInteractor: FLogInteractorInputProtocol {
    var presenter: ViperInteractorOutput?
    
    func createSampleData() {
        if UserDefaults.standard.value(forKey: Common.Define.mainRoutine) == nil {

            // main routine array structure
            UserDefaults.standard.set([[Common.Define.mainRoutineTitle:"Leg Day(Sample)", Common.Define.mainRoutineUnit:Common.Define.mainRoutineUnitKg, Common.Define.mainRoutineExercises:["Back Squat", "Split Squat", "Walking Lunge", "Sled Push"]]], forKey: Common.Define.mainRoutine)
            var oneweekago = Date()
            oneweekago.addTimeInterval(-(60*60*24*7))
            var twoweeksago = Date()
            twoweeksago.addTimeInterval(-(60*60*24*14))
            
            // detail array structure
            UserDefaults.standard.set([[Common.Define.routineDetailLogDate:DateFormatter.localizedString(from: twoweeksago, dateStyle: .medium, timeStyle: .none),
                                        "Back Squat":[[Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"],
                                                      [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"],
                                                      [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"],
                                                      [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"5"],
                                                      [Common.Define.routineDetailWeight:"130", Common.Define.routineDetailReps:"10"]],
                                        "Split Squat":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"12"]],
                                        "Walking Lunge":[[Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"15"]],
                                        "Sled Push":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"]] ],
                                       
                                        [Common.Define.routineDetailLogDate:DateFormatter.localizedString(from: oneweekago, dateStyle: .medium, timeStyle: .none),
                                        "Back Squat":[[Common.Define.routineDetailWeight:"140", Common.Define.routineDetailReps:"6"],
                                                      [Common.Define.routineDetailWeight:"145", Common.Define.routineDetailReps:"5"],
                                                      [Common.Define.routineDetailWeight:"150", Common.Define.routineDetailReps:"5"],
                                                      [Common.Define.routineDetailWeight:"155", Common.Define.routineDetailReps:"4"],
                                                      [Common.Define.routineDetailWeight:"160", Common.Define.routineDetailReps:"2"]],
                                        "Split Squat":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"95", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"95", Common.Define.routineDetailReps:"8"],
                                                       [Common.Define.routineDetailWeight:"100", Common.Define.routineDetailReps:"7"]],
                                        "Walking Lunge":[[Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"10"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"10"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"10"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"8"],
                                                         [Common.Define.routineDetailWeight:"40", Common.Define.routineDetailReps:"7"]],
                                        "Sled Push":[[Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"],
                                                     [Common.Define.routineDetailWeight:"90", Common.Define.routineDetailReps:"2"]] ]],
                                      
                                      forKey: "Leg Day(Sample)_detail")
        }
        
        if !UserDefaults.standard.bool(forKey: Common.Define.checkBestCreatedBefore) {
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
            UserDefaults.standard.set(true, forKey: Common.Define.checkBestCreatedBefore)
        }
    }
    
    func loadData(with initialData: ViperEntity?) {
        if let _presenter = presenter as? FLogInteractorOutputProtocol {
            let loadedArray = UserDefaults.standard.array(forKey: Common.Define.mainRoutine) as! Array<Dictionary<String, Any>>
            var routines = Array<MainRoutineModel>()
            for loadedData in loadedArray {
                let routine = MainRoutineModel(title: loadedData[Common.Define.mainRoutineTitle] as! String, unit: loadedData[Common.Define.mainRoutineUnit] as! String, exerciseTitles: loadedData[Common.Define.mainRoutineExercises] as! [String])
                routines.append(routine)
            }
            
            _presenter.didDataLoaded(with: FlogEntity(flogArray: routines))
        }
    }
    
    private func updateRoutine(routineArray: Array<Dictionary<String, Any>>) {
        UserDefaults.standard.set(routineArray, forKey: Common.Define.mainRoutine)
    }
    
    func deleteRoutine(index: Int) {
        
        var routineArray = UserDefaults.standard.array(forKey: Common.Define.mainRoutine) as! Array<Dictionary<String, Any>>
        let data: Dictionary<String, Any> = routineArray[index]
        let title: String = data[Common.Define.mainRoutineTitle] as! String
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                let managedOC = appDelegate.persistentContainer.viewContext
                let request: NSFetchRequest<Timeline> = NSFetchRequest(entityName: String(describing: Timeline.self))
                request.predicate = NSPredicate(format: "routineTitle == %@", title)
                let timelineList = try managedOC.fetch(request)
                for timeline in timelineList {
                    managedOC.delete(timeline)
                    try managedOC.save()
                }
            } catch {
            }
        }

        UserDefaults.standard.removeObject(forKey: title + Common.Define.routineDetail)
        UserDefaults.standard.removeObject(forKey: title + Common.Define.routineBest)

        routineArray.remove(at: index)
        updateRoutine(routineArray: routineArray)

        loadData()
    }
    
    
    func replaceRoutines(sourceIndex: Int, destinationIndex: Int) {
        var routineArray = UserDefaults.standard.array(forKey: Common.Define.mainRoutine) as! Array<Dictionary<String, Any>>
        let sourceItem: Dictionary<String, Any> = routineArray[sourceIndex]

        routineArray.remove(at: sourceIndex)
        routineArray.insert(sourceItem, at: destinationIndex)
        updateRoutine(routineArray: routineArray)
        
        loadData()
    }
    
    func updateRoutineTitle(index: Int, newTitle: String) {
        var routineArray = UserDefaults.standard.array(forKey: Common.Define.mainRoutine) as! Array<Dictionary<String, Any>>
        var item: Dictionary<String, Any> = routineArray[index]
        let originalTitle = item[Common.Define.mainRoutineTitle] as? String
        
        if originalTitle == newTitle {
            return
        } else {
            
            for (i, routine) in routineArray.enumerated() {
                if i == index {
                    continue
                }
                
                let routineDict = routine
                if routineDict[Common.Define.mainRoutineTitle] as? String == newTitle {
                    presenter?.onError(title: "Failed", message: newTitle + " already exists\nPlease enter another name", buttonTitle: "OK", handler: { (_) in
                    })
                    return
                }
            }
            
            item[Common.Define.mainRoutineTitle] = newTitle

            routineArray.remove(at: index)
            routineArray.insert(item, at: index)
            updateRoutine(routineArray: routineArray)


            let detailArray = UserDefaults.standard.array(forKey: originalTitle! + Common.Define.routineDetail)
            let bestDictionary = UserDefaults.standard.dictionary(forKey: originalTitle! + Common.Define.routineBest)

            UserDefaults.standard.removeObject(forKey: originalTitle! + Common.Define.routineDetail)
            UserDefaults.standard.removeObject(forKey: originalTitle! + Common.Define.routineBest)

            UserDefaults.standard.set(detailArray, forKey: newTitle + Common.Define.routineDetail)
            UserDefaults.standard.set(bestDictionary, forKey: newTitle + Common.Define.routineBest)
            
            loadData()
        }
    }
}
