//
//  RoutineDetailModel.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

/**
 Structure that is used for holding Routine Detail Data.
 */
public struct RoutineDetailModelaaaa {
    
    /// Main Routine data for this Routine Detail data
    public var routine: MainRoutineModel
    
    /// Daily logs data that can be selected in SegmentedControl
    public var dailyLogs: [DailyLogModel]
}
