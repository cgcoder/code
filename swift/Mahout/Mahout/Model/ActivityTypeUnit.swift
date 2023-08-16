//
//  ActivityTypeUnit.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/16/23.
//

import Foundation

@objc
public enum ActivityTypeUnit: Int {
    case laps = 1, duration = 2, friction = 3, inclination = 4, tension = 5, weightLb = 6, weightKg = 7, distanceMiles = 8, distanceKm = 9, floors = 10
}

@objc(ActivityTypeUnitValue)
public class ActivityTypeUnitValue: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    public var units: [ActivityTypeUnit] = []
    
    enum Key: String {
        case units = "units"
    }
    
    public init(units: [ActivityTypeUnit]) {
        self.units = units
    }
    
    public func encode(with coder: NSCoder) {
        let array = units.map { $0.rawValue }.map { String($0)}.joined(separator: ",")
        coder.encode(array, forKey: Key.units.rawValue)
    }
    
    public convenience required init?(coder: NSCoder) {
        
        let arrayStr = coder.decodeObject(forKey: Key.units.rawValue) as! String
        let units = arrayStr.split(separator: ",").map { Int($0) }.filter { $0 != nil }.map { ActivityTypeUnit(rawValue: $0!) }.filter { $0 != nil }.map { $0! }
        self.init(units: units)
    }
}
