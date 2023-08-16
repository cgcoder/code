//
//  AddActivityModel.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//


import PhotosUI
import SwiftUI
import CoreData

final class AddActivityModel: ObservableObject {
    @Published var uniqueId: String = ""
    @Published var name: String = ""
    @Published var inputInfo: String = ""
    @Published var imageType: String = "Predefined Image"
    
    @Published var selectedPredefinedImage: String = "treadmill"
    @Published var selectedPictureItem: PhotosPickerItem? = nil
    @Published var error: Error? = nil
    @Published var selectedImageData: Data? = nil
    @Published var selectedImage: UIImage?
    @Published var isInclinationBased: Bool = false
    @Published var isTensionBased: Bool = false
    @Published var isFrictionBased: Bool = false
    @Published var isLapBased: Bool = false
    @Published var isLBWeightBased: Bool = false
    @Published var isKgWeightBased: Bool = false
    @Published var isMilesBased: Bool = false
    @Published var isKmBased: Bool = false
    @Published var isFloorsBased: Bool = false
    @Published var isDurationBased: Bool = false
    
    static let unitMappings: [(WritableKeyPath<AddActivityModel, Bool>, ActivityTypeUnit)] =
                [(\Self.isInclinationBased, .inclination),
                 (\Self.isTensionBased, .tension),
                 (\Self.isFrictionBased, .friction),
                 (\Self.isLapBased, .laps),
                 (\Self.isLBWeightBased, .weightLb),
                 (\Self.isKgWeightBased, .weightKg),
                 (\Self.isMilesBased, .distanceMiles),
                 (\Self.isKmBased, .distanceKm),
                 (\Self.isFloorsBased, .floors),
                 (\Self.isDurationBased, .duration)]
    
    func validate() throws {
        
        let requiredFields: [(String, KeyPath<AddActivityModel, String>)] =
            [("Activity Name", \Self.name), ("Description", \Self.inputInfo)]
        
        let requiredToggle: [KeyPath<AddActivityModel, Bool>] =
        [\Self.isInclinationBased, \Self.isTensionBased, \Self.isFrictionBased, \Self.isLapBased, \Self.isLBWeightBased, \Self.isKgWeightBased, \Self.isMilesBased, \Self.isKmBased, \Self.isFloorsBased, \Self.isDurationBased]
        
        for requiredField in requiredFields {
            if (self[keyPath: requiredField.1].trimmingCharacters(in: .whitespaces).count == 0) {
                throw AppError(err: "\(requiredField.0) is required")
            }
        }
        
        print("isTensionBased \(self.isTensionBased)")
        
        requiredToggle.filter {
            print("\(self[keyPath: $0]) <-- \($0)")
            return true
        }
        
        if requiredToggle.filter({ self[keyPath: $0] }).count == 0 {
            throw AppError(err: "Must pick atleast one activity type")
        }
    }
    
    func asDBModel(context: NSManagedObjectContext) -> ActivityTypes {
        let info = inputInfo.trimmingCharacters(in: .whitespaces)
        let name = name.trimmingCharacters(in: .whitespaces)
        let image = selectedPredefinedImage.trimmingCharacters(in: .whitespaces)
        let activityType = ActivityTypes(context: context)
        activityType.info = info
        activityType.name = name
        activityType.image = image
        activityType.id = UUID().uuidString
        activityType.imageData = selectedImageData
        
        let units = Self.unitMappings.filter({self[keyPath: $0.0]}).map({$0.1})
        activityType.units = ActivityTypeUnitValue(units: units)
        
        return activityType
    }
}

extension ActivityTypes {
    func asUIModel() -> AddActivityModel {
        var model = AddActivityModel()
        model.uniqueId = self.id ?? ""
        model.name = self.name!
        model.inputInfo = self.info ?? ""
        model.imageType = self.image?.count ?? 0 > 0 ? "Predefined Image" : "Custom Image"
        model.selectedImageData = self.imageData
        if self.image != nil { model.selectedPredefinedImage = self.image! }
        let units = self.units?.units ?? []
        for mapping in AddActivityModel.unitMappings {
            if (units.contains(mapping.1)) {
                model[keyPath: mapping.0] = true
            }
        }
        return model
    }
}
