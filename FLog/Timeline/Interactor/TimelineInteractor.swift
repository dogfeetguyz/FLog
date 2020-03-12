//
//  TimelineInteractor.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import CoreData
import UIKit

class TimelineInteractorInput: TimelineInteractorInputProtocol {
    var presenter: TimelineInteractorOutputProtocol?
    
    func createTimelineData() {
        if !UserDefaults.standard.bool(forKey: Common.Define.checkTimelineCreatedBefore) {
            UserDefaults.standard.set(true, forKey: Common.Define.checkTimelineCreatedBefore)
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                do {
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
        }
    }
    
    func dispatchTimelines() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedOC = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<Timeline> = NSFetchRequest(entityName: String(describing: Timeline.self))
            request.fetchLimit = 50
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            do {
                let timelineList = try managedOC.fetch(request)
                presenter?.didDispatchTimelines(with: timelineList)
            } catch {
                presenter?.didDispatchTimelines(with: [])
            }
        } else {
            presenter?.didDispatchTimelines(with: [])
        }
    }
}
