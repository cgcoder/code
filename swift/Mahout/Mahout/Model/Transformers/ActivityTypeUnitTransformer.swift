//
//  ActivityTypeUnitTransformer.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/16/23.
//

import UIKit

@objc(ActivityTypeUnitTransformer)
class ActivityTypeUnitTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? ActivityTypeUnitValue else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let value = try NSKeyedUnarchiver.unarchivedObject(ofClass: ActivityTypeUnitValue.self, from: data)
            return value
        } catch {
            print(error)
            return nil
        }
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(ActivityTypeUnitTransformer(), forName: .activityTypeUnitToDataTransformer)
    }
}

extension NSValueTransformerName {
    static let activityTypeUnitToDataTransformer = NSValueTransformerName(rawValue: String(describing: ActivityTypeUnitTransformer.self))
}
