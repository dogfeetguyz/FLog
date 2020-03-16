//
//  TimelineInteractor.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import CoreData
import UIKit

class TimelineInteractor: TimelineInteractorInputProtocol {
    var presenter: TimelineInteractorOutputProtocol?
    var fetchOffset = 0
    
    func createTimelineData() {
        if !UserDefaults.standard.bool(forKey: Common.Define.checkTimelineCreatedBefore) {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                var timelineList = Array<Dictionary<String, String>>()
                let mainRoutine = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)!
                for dict in mainRoutine {
                    let routineDict = dict as! Dictionary<String, Any>
                    let routineTitle = routineDict[Common.Define.mainRoutineTitle] as! String
                    let routineDetailArray = UserDefaults.standard.array(forKey: routineTitle + Common.Define.routineDetail)!
                    
                    for routineDetail in routineDetailArray {
                        let date = (routineDetail as! Dictionary<String, Any>)[Common.Define.mainRoutineTitle] as! String
                        
                        timelineList.append(["title":routineTitle, "date":date])
                    }
                }
                
                timelineList.sort(by: {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .none
                    
                    let date1 = formatter.date(from: $0["date"]!)
                    let date2 = formatter.date(from: $1["date"]!)
                    
                    return date1! < date2!

                })
                
                let managedOC = appDelegate.persistentContainer.viewContext
                let request: NSFetchRequest<Timeline> = NSFetchRequest(entityName: String(describing: Timeline.self))
                let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
                
                do {
                    try appDelegate.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: managedOC)
                    
                    for (index, dict) in timelineList.enumerated() {
                        let entity = NSEntityDescription.entity(forEntityName: String(describing: Timeline.self ), in: managedOC)
                        let timeline = Timeline(entity: entity!, insertInto: managedOC)
                        timeline.id = Int32(index)
                        timeline.logDate = dict["date"]
                        timeline.routineTitle = dict["title"]
                        try managedOC.save()
                    }
                    
                } catch {
                }
            } else {
            }
            UserDefaults.standard.set(true, forKey: Common.Define.checkTimelineCreatedBefore)
        }
    }
    
    func dispatchTimelines(isInitial: Bool) {
        if isInitial {
            fetchOffset = 0
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedOC = appDelegate.persistentContainer.viewContext
            do {
                while true {
                    let request: NSFetchRequest<Timeline> = NSFetchRequest(entityName: String(describing: Timeline.self))
                    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
                    request.fetchLimit = Common.Define.dbRequestLimit
                    request.fetchOffset = fetchOffset
                    
                    let fetchedList = try managedOC.fetch(request)
                    
                    var timelinelList = Array<TimelineModel>()
                    for timeline in fetchedList {
                        var contentString = ""
                        var totalWeight = 0

                        var routine:MainRoutineModel?
                        let loadedArray = UserDefaults.standard.array(forKey: Common.Define.mainRoutine) as! Array<Dictionary<String, Any>>
                        for loadedData in loadedArray {
                            if (loadedData[Common.Define.mainRoutineTitle] as! String) == timeline.routineTitle {
                                routine = MainRoutineModel(title: loadedData[Common.Define.mainRoutineTitle] as! String, unit: loadedData[Common.Define.mainRoutineUnit] as! String, exerciseTitles: loadedData[Common.Define.mainRoutineExercises] as! [String])
                                break
                            }
                        }
                        
                        let unit = routine?.unit
                        for arrayItem in UserDefaults.standard.array(forKey: timeline.routineTitle! + Common.Define.routineDetail)! {
                            let dict: Dictionary<String, Any> = arrayItem as! Dictionary<String, Any>
                            if (dict[Common.Define.routineDetailLogDate] as! String) == timeline.logDate! {
                                for exerciseTitle in routine!.exerciseTitles {
                                    
                                    var setString = ""
                                    var totalSetWeight = 0
                                    let setArray: Array<Dictionary<String, String>> = dict[exerciseTitle] as! Array<Dictionary<String, String>>
                                    for setDictionary in setArray {
                                        let weight = Int(setDictionary[Common.Define.routineDetailWeight]!) ?? 0
                                        let reps = Int(setDictionary[Common.Define.routineDetailReps]!) ?? 0
                                        
                                        if weight > 0 && reps > 0 {
                                            totalSetWeight = totalSetWeight + (weight*reps)
                                            setString = "\(setString) - \(setDictionary[Common.Define.routineDetailWeight]!)\(unit!) x \(setDictionary[Common.Define.routineDetailReps]!)reps\n"
                                        }
                                    }
                                    
                                    if setString.count > 0 {
                                        setString = "\(setString) - Total \(exerciseTitle): \(totalSetWeight)\(unit!)\n\n"
                                        contentString = contentString + exerciseTitle + "\n" + setString
                                        totalWeight = totalWeight + totalSetWeight
                                    }
                                }
                                break
                            }
                        }
                        
                        fetchOffset += 1
                        if contentString.count > 0 {
                            contentString = "\(contentString)Total: \(totalWeight)\(unit!)"
                            let string = NSAttributedString(string: contentString)
                            timelinelList.append(TimelineModel(timelineData: timeline, content: string))
                            
                            if timelinelList.count == Common.Define.dbResultLimit {
                                break
                            }
                        }
                    }
                    
                    if fetchedList.count < Common.Define.dbRequestLimit {
                        if timelinelList.count == 0 {
                            presenter?.onError(isInitial: isInitial)
                        } else {
                            presenter?.didDispatchTimelines(with: timelinelList, isInitial: isInitial)
                        }
                        break
                    } else {
                        if timelinelList.count == Common.Define.dbResultLimit {
                            presenter?.didDispatchTimelines(with: timelinelList, isInitial: isInitial)
                            break
                        } else {
                            continue
                        }
                    }
                }
            } catch {
                presenter?.onError(isInitial: isInitial)
            }
        } else {
            presenter?.onError(isInitial: isInitial)
        }
    }
}
