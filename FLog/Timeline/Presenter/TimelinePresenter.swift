//
//  TimelinePresenter.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class TimelinePresenter: TimelinePresenterProtocol {
    weak var view: TimelineViewProtocol?
    var wireFrame: TimelineWireFrameProtocol?
    var interactor: TimelineInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.createTimelineData()
        interactor?.dispatchTimelines(isInitial: true)
    }
    
    func tableViewScrollToBottom() {
        interactor?.dispatchTimelines(isInitial: false)
    }
}

extension TimelinePresenter: TimelineInteractorOutputProtocol {
    func didDispatchTimelines(with timelineArray: [TimelineModel], isInitial: Bool) {
        view?.showTimelines(with: timelineArray, isInitial: isInitial)
    }
    
    func onError(isInitial: Bool) {
        view?.onError(isInitial: isInitial)
    }
    
}
