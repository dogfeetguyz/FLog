//
//  NewRoutineInteractor.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation

class NewRoutineInteractor: NewRoutineInteractorInputProtocol {
    var presenter: NewRoutineInteractorOutputProtocol?
    
    func createNewRoutine(title: String?, unitIndex: Int, routine: Array<String?>) {
        if title!.count == 0 {
            presenter?.onError(title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: { (_) in
                
            })
        } else {
            var routines = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)
            var dict: Dictionary = Dictionary<String, Any>()
            
            for routine in routines! {
                let routineDict = routine as! Dictionary<String, Any>
                if routineDict[Common.Define.mainRoutineTitle] as? String == title {
                    presenter?.onError(title: "Failed", message: (title ?? "") + " already exists\nPlease enter another name", buttonTitle: "OK", handler: { (_) in
                        
                    })
                    return
                }
            }
            
            dict[Common.Define.mainRoutineTitle] = title
            
            if unitIndex == 0 {
                dict[Common.Define.mainRoutineUnit] = Common.Define.mainRoutineUnitKg
            } else {
                dict[Common.Define.mainRoutineUnit] = Common.Define.mainRoutineUnitLb
            }
            
            for exercise in routine {
                if exercise!.count == 0 {
                    presenter?.onError(title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: { (_) in
                        
                    })
                    return
                }
            }
            
            dict[Common.Define.mainRoutineExercises] = routine
            routines?.append(dict)
            
            UserDefaults.standard.set(routines, forKey: Common.Define.mainRoutine)
            

            var bestDict = Dictionary<String, Dictionary<String, String>>()
            for exercise in routine {
                bestDict[exercise!] = Dictionary<String, String>()
                bestDict[exercise!]![Common.Define.mainRoutineUnit] = dict[Common.Define.mainRoutineUnit] as? String
                bestDict[exercise!]![Common.Define.routineBestMaxVolume] = "0"
                bestDict[exercise!]![Common.Define.routineBestMaxVolumeDate] = ""
                bestDict[exercise!]![Common.Define.routineBestMaxWeight] = "0"
                bestDict[exercise!]![Common.Define.routineBestMaxWeightDate] = ""
            }
            UserDefaults.standard.set(bestDict, forKey: title! + Common.Define.routineBest)

            presenter?.didCreateNewRoutine()
        }
    }
    
}
