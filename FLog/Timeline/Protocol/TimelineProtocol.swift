//
//  TimelineProtocol.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

protocol TimelineViewProtocol: ViperView {
    ///check If it is an initial request or paging request
    var isInitial: Bool { get set }
}

extension TimelineViewProtocol {
    func updateVIew(with entity: ViperEntity, isInitial: Bool) {
        self.isInitial = isInitial
        updateVIew(with: entity)
    }
    
    func showError(isInitial: Bool) {
        self.isInitial = isInitial
        showError(title: "", message: "", buttonTitle: "", handler: nil)
    }
}


protocol TimelineInteractorInputProtocol: ViperInteractorInput {
    ///check If it is an initial request or paging request
    var isInitial: Bool { get set }
    ///offset for fetching data from Core Data
    var fetchOffset: Int { get set }
    
    /// Creates TImeline data for the first execute
    func createTimelineData()
}

extension TimelineInteractorInputProtocol {
    func loadData(isInitial: Bool) {
        self.isInitial = isInitial
        loadData()
    }
}

protocol TimelineInteractorOutputProtocol: ViperInteractorOutput {
    ///check If it is an initial request or paging request
    var isInitial: Bool { get set }
}

extension TimelineInteractorOutputProtocol {
    func didDataLoaded(with loadedData: ViperEntity, isInitial: Bool) {
        self.isInitial = isInitial
        didDataLoaded(with: loadedData)
    }
    
    func onError(isInitial: Bool) {
        self.isInitial = isInitial
        onError(title: "", message: "", buttonTitle: "", handler: nil)
    }
}

protocol TimelinePresenterProtocol: ViperPresenter {
    /// Should call after the user scrolls the tableview to the bottom
    func tableViewScrollToBottom()
}

protocol TimelineEntityProtocol: ViperEntity {
    var timelineArray: Array<TimelineModel> { get set }
}

protocol TimelineRouterProtocol: ViperRouter {
}
