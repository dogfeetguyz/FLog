//
//  RoutineDetailEntity.swift
//  FLog
//
//  Created by Yejun Park on 19/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation

class RoutineDetailEntity: RoutineDetailEntityProtocol {
    var routine: MainRoutineModel
    
    var dailyLogs: [DailyLogModel]
    
    init(routine: MainRoutineModel, dailyLogs: [DailyLogModel]) {
        self.routine = routine
        self.dailyLogs = dailyLogs
    }
}
