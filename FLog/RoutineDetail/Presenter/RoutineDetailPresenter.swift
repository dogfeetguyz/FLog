//
//  RoutineDetailPresenter.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineDetailPresenter: RoutineDetailPresenterProtocol {
    var view: ViperView?
    var interactor: ViperInteractorInput?
    var router: ViperRouter?
    
    func viewDidLoad() {
        loadMaxInfo()
        loadLogs()
    }
    
    func loadLogs() {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.loadLogs(routine: _routineDetailData.routine)
            }
        }
    }
    
    func loadMaxInfo() {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.loadMaxInfo(routineTitle: _routineDetailData.routine.title)
            }
        }
    }
    
    func textfieldUpdated(setIndex: Int, slotIdentifier:Slot, text: String, logDate: String, exerciseTitle: String) {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.updateSet(routine: _routineDetailData.routine, setIndex: setIndex, slotIdentifier: slotIdentifier, text: text, logDate: logDate, exerciseTitle: exerciseTitle)
            }
        }
    }
    
    func finishedInputData(logDate: String) {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.updateMaxValueIfNeeded(routineTitle: _routineDetailData.routine.title, logDate: logDate)
            }
        }
    }
    
    func newLogAction(date: Date) {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.createLog(date: date, routine: _routineDetailData.routine)
            }
        }
    }
    
    func removeLogAction(removeIndex: Int) {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.removeLog(removeIndex: removeIndex, routine: _routineDetailData.routine)
            }
        }
    }
    
    func addSetAction(logDate: String, exerciseTitle: String) {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.createSet(routine: _routineDetailData.routine, logDate: logDate, exerciseTitle: exerciseTitle)
            }
        }
    }
    
    func removeSetAction(logDate: String, exerciseTitle: String) {
        if let _interactor = interactor as? RoutineDetailInteractorInputProtocol {
            if let _routineDetailData = view?.loadedData as? RoutineDetailEntityProtocol {
                _interactor.removeSet(routine: _routineDetailData.routine, logDate: logDate, exerciseTitle: exerciseTitle)
            }
        }
    }
}

extension RoutineDetailPresenter: RoutineDetailInteractorOutputProtocol {
    func didDataLoaded(with loadedData: ViperEntity) {
        
    }
    
    
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>) {
        if let _view = view as? RoutineDetailView {
            _view.updateMaxInfoView(maxInfo: maxInfo)
        }
    }
    
    func didLogLoaded(routineDetail: ViperEntity) {
        if let _view = view as? RoutineDetailView {
            _view.showRoutineDetail(routineDetail: routineDetail)
        }
    }
    
    func didCreateLog() {
        if let _view = view as? RoutineDetailView {
            _view.updateLogView(segmentIndex: 0)
        }
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        if let _view = view as? RoutineDetailView {
            if title == "" && message == "" && buttonTitle == "" && handler == nil {
                _view.showCreateDialog(isFirst: true)
            } else {
                _view.showError(title: title, message: message, buttonTitle: buttonTitle, handler: handler)
            }
        }
    }
    
    func didRemoveLog(removedIndex: Int) {
        if let _view = view as? RoutineDetailView {
            _view.updateLogView(segmentIndex: removedIndex)
        }
    }
    
    func didUpdateSetData(routineDetail: ViperEntity) {
        if let _view = view as? RoutineDetailView {
            _view.updateTableView(routineDetail: routineDetail)
        }
    }
}
