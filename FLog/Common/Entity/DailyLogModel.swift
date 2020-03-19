//
//  ExerciseDateModel.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

/**
 Structure that is used for holding Daily log data.
 */
public class DailyLogModel: ViperEntity {
    
    /// The date for this log
    public var logDate: String = ""
    
    /// logs for each exercise in the date
    public var exerciseLogs: [ExerciseLogModel]
    
    init(logDate: String, exerciseLogs: [ExerciseLogModel]) {
        self.logDate = logDate
        self.exerciseLogs = exerciseLogs
    }
}

