//
//  SetModel.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

/**
 Structure that is used for holding Set Data.
 */
public class SetModel: ViperEntity {
    
    /// How much weight
    public var weight: String = ""
    
    /// How many reps
    public var reps = ""
    
    init(weight: String, reps: String) {
        self.weight = weight
        self.reps = reps
    }
}
