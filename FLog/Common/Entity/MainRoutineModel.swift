//
//  MainRoutineModel.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

/**
 Structure that is used for holding Main Routine data.
 */
public class MainRoutineModel: ViperEntity {
    /// Routine Routine tItle
    public var title: String = ""
    
    /// Unit String. default: "kg"
    public var unit = "kg"
    
    /// Array of exercise titles
    public var exerciseTitles = Array<String>()
    
    init(title: String, unit: String, exerciseTitles: Array<String>) {
        self.title = title
        self.unit = unit
        self.exerciseTitles = exerciseTitles
    }
}
