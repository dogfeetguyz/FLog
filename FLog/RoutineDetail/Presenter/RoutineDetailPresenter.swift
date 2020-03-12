//
//  RoutineDetailPresenter.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineDetailPresenter: RoutineDetailPresenterProtocol {
    
    var view: RoutineDetailViewProtocol?
    
    var interactor: RoutineDetailInteractorInputProtocol?
    
    var wireFrame: RoutineDetailWireFrameProtocol?
    
    func viewDidLoad() {
        loadMaxInfo()
        loadLogs()
    }
    
    func loadLogs() {
        interactor?.loadLogs(routine: (view?.routineDetailData!.routine)!)
    }
    
    func loadMaxInfo() {
        interactor?.loadMaxInfo(routineTitle: (view?.routineDetailData?.routine.title)!)
    }
    
    func textfieldUpdated(tag: String, text: String, logDate: String, exerciseTitle: String) {
        interactor?.updateSet(routineDetail: view!.routineDetailData!, tag: tag, text: text, logDate: logDate, exerciseTitle: exerciseTitle)
    }
    
    func finishedInputData(logDate: String) {
        interactor?.checkNewMaxInfo(routineTitle: (view?.routineDetailData?.routine.title)!, logDate: logDate)
    }
    
    func newLogAction(date: Date) {
        interactor?.createNewFitnessLog(date: date, routine: view!.routineDetailData!.routine)
    }
    
    func deleteLogAction(deleteIndex: Int) {
        interactor?.deleteFitnessLog(deleteIndex: deleteIndex, routine: view!.routineDetailData!.routine)
    }
    
    func updateMaxInfo(exerciseTitle: String) {
        interactor?.refindMaxValue(routineTitle: view!.routineDetailData!.routine.title, exerciseTitle: exerciseTitle)
    }
    
    func addSetAction(logDate: String, exerciseTitle: String) {
        interactor?.createNewSet(routineDetail: view!.routineDetailData!, logDate: logDate, exerciseTitle: exerciseTitle)
    }
    
    func removeSetAction(logDate: String, exerciseTitle: String) {
        interactor?.removeSet(routineDetail: view!.routineDetailData!, logDate: logDate, exerciseTitle: exerciseTitle)
    }
}

extension RoutineDetailPresenter: RoutineDetailInteractorOutputProtocol {
    
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>) {
        view?.updateMaxInfoView(maxInfo: maxInfo)
    }
    
    func didLogLoaded(routineDetail: RoutineDetailModel) {
        view?.showRoutineDetail(routineDetail: routineDetail)
    }
    
    func didUpdateLog(routineDetail: RoutineDetailModel) {
        view?.updateTableView(routineDetail: routineDetail)
    }
    
    func needsFirstLog() {
        view?.showCreateDialog(isFirst: true)
    }
    
    func didCreateNewFitnessLog() {
        view?.updateLogView(segmentIndex: 0)
    }
    
    func didDeleteFitnessLog(deletedIndex: Int) {
        view?.updateLogView(segmentIndex: deletedIndex)
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        view?.showError(title: title, message: message, buttonTitle: buttonTitle, handler: handler)
    }
}
