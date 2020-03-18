//
//  NewRoutineInteractor.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation

class NewRoutineInteractor: NewRoutineInteractorInputProtocol {
    var presenter: ViperInteractorOutput?
    
    func loadData(with initialData: ViperEntity?) { }
    
    func createNewRoutine(title: String?, unit: Unit, exerciseTitles: Array<String?>) {
        if let _presenter = presenter as? NewRoutineInteractorOutputProtocol {
            if title!.count == 0 {
                _presenter.onError(title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: nil)
            } else {
                var routines = UserDefaults.standard.array(forKey: Common.Define.mainRoutine)
                var dict: Dictionary = Dictionary<String, Any>()
                
                for routine in routines! {
                    let routineDict = routine as! Dictionary<String, Any>
                    if routineDict[Common.Define.mainRoutineTitle] as? String == title {
                        presenter?.onError(title: "Failed", message: (title ?? "") + " already exists\nPlease enter another name", buttonTitle: "OK", handler: nil)
                        return
                    }
                }
                
                dict[Common.Define.mainRoutineTitle] = title
                
                if unit == .kg {
                    dict[Common.Define.mainRoutineUnit] = Common.Define.mainRoutineUnitKg
                } else {
                    dict[Common.Define.mainRoutineUnit] = Common.Define.mainRoutineUnitLb
                }
                
                let dictinctArray = Array(Set(exerciseTitles))
                if exerciseTitles.count != dictinctArray.count {
                    _presenter.onError(title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: nil)
                    return
                } else {
                    if exerciseTitles.count == 0 {
                        _presenter.onError(title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: nil)
                        return
                    } else {
                        for exerciseTitle in exerciseTitles {
                            if exerciseTitle!.count == 0 {
                                _presenter.onError(title: "Failed", message: "Please fill the blanks", buttonTitle: "OK", handler: nil)
                                return
                            }
                        }
                        
                        dict[Common.Define.mainRoutineExercises] = exerciseTitles
                        routines?.append(dict)
                        
                        UserDefaults.standard.set(routines, forKey: Common.Define.mainRoutine)
                        

                        var bestDict = Dictionary<String, Dictionary<String, String>>()
                        for exerciseTitle in exerciseTitles {
                            bestDict[exerciseTitle!] = Dictionary<String, String>()
                            bestDict[exerciseTitle!]![Common.Define.mainRoutineUnit] = dict[Common.Define.mainRoutineUnit] as? String
                            bestDict[exerciseTitle!]![Common.Define.routineBestMaxVolume] = "0"
                            bestDict[exerciseTitle!]![Common.Define.routineBestMaxVolumeDate] = ""
                            bestDict[exerciseTitle!]![Common.Define.routineBestMaxWeight] = "0"
                            bestDict[exerciseTitle!]![Common.Define.routineBestMaxWeightDate] = ""
                        }
                        UserDefaults.standard.set(bestDict, forKey: title! + Common.Define.routineBest)
                        UserDefaults.standard.set([], forKey: title! + Common.Define.routineDetail)

                        _presenter.didCreateNewRoutine()
                    }
                }
            }
        }
    }
}
