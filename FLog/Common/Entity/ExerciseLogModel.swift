//
//  ExerciseModel.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

/**
 Structure that is used for holding Exercise log data.
 */
public class ExerciseLogModel: ViperEntity {
    
    /// Exercise title for this log
    public var exerciseTitle: String = ""
    
    /// Each set for this log containing weight and repetitions
    public var set: [SetModel]
    
    init(exerciseTitle: String, set: [SetModel]) {
        self.exerciseTitle = exerciseTitle
        self.set = set
    }
}

