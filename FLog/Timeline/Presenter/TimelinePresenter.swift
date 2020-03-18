//
//  TimelinePresenter.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class TimelinePresenter: TimelinePresenterProtocol {
    var view: ViperView?
    var interactor: ViperInteractorInput?
    var wireFrame: ViperRouter?
    
    var isInitial: Bool = false
    
    
    func viewDidLoad() {
        if let _interactor = interactor as? TimelineInteractorInputProtocol {
            _interactor.createTimelineData()
            _interactor.loadData(isInitial: true)
        }
    }
    
    func tableViewScrollToBottom() {
        if let _interactor = interactor as? TimelineInteractorInputProtocol {
            _interactor.loadData(isInitial: false)
        }
    }
}

extension TimelinePresenter: TimelineInteractorOutputProtocol {
    
    func didDataLoaded(with loadedData: ViperEntity) {
        if let _view = view as? TimelineViewProtocol {
            _view.updateVIew(with: loadedData, isInitial: isInitial)
        }
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        if let _view = view as? TimelineView {
            _view.showError(isInitial: isInitial)
        }
    }
}
