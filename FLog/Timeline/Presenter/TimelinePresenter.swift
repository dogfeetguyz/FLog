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
        interactor?.dispatchTimelines()
    }
}

extension TimelinePresenter: TimelineInteractorOutputProtocol {
    // MARK: interactor -> presenter
    /// Finished dispatching Timelines from UserDefaults
    /// - parameter mainTimelineModelArray: An array of MainTimelineModel loaded from UserDefaults
    func didDispatchTimelines(with timelineArray: [Timeline]) {
        view?.showTimelines(with: timelineArray)
    }
}
