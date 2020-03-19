//
//  RoutineBestModel.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

/**
 Structure that is used for holding Routine Best Data.
 */
public class RoutineBestModel: ViperEntity {
    /// Maximum Volume
    public var maxVolume: String = ""
    
    /// Maximum Volume Date
    public var maxVolumeDate: String = ""
    
    /// Maximum Weight
    public var maxWeight: String = ""
    
    /// Maximum Weight Date
    public var maxWeightDate: String = ""
    
    init(maxVolume: String, maxVolumeDate: String, maxWeight: String, maxWeightDate: String) {
        self.maxVolume = maxVolume
        self.maxVolumeDate = maxVolumeDate
        self.maxWeight = maxWeight
        self.maxWeightDate = maxWeightDate
    }
}
