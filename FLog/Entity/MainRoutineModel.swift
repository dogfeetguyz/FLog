//
//  MainRoutineModel.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

/**
 Structure that is used for holding Main Routine daata.
 */
public struct MainRoutineModel {
    /// Routine Routine tItle
    public var title: String = ""
    
    /// Unit String. default: "kg"
    public var unit = "kg"
    
    /// Array of exercise titles
    public var exerciseTitles = Array<String>()
}
