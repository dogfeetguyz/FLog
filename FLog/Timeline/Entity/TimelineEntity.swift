//
//  TimelineEntity.swift
//  FLog
//
//  Created by Yejun Park on 19/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation

class TimelineEntity: TimelineEntityProtocol {
    var timelineArray: Array<TimelineModel>
    
    init(timelineArray: Array<TimelineModel>) {
        self.timelineArray = timelineArray
    }
}
