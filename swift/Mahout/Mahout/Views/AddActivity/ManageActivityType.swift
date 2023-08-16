//
//  AddActivityTypeView.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//

import SwiftUI
import PhotosUI

struct ManageActivityType: View {
        
    let predefinedImages = ["noimage", "treadmill", "elliptical", "rowing"]
    
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var model: AddActivityModel
    
    init(model: AddActivityModel = AddActivityModel()) {
        self.model = model
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    TextField("Name", text: $model.name).textFieldStyle(.roundedBorder)
                }
                HStack {
                    TextField("Description", text: $model.inputInfo).textFieldStyle(.roundedBorder)
                }
                HStack {
                    
                }
                ActivityImagePicker(model: model)
                ActivitySettingView(model: model)
                Spacer()
            }
            .padding()
            .navigationTitle("Add Activity Type")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !(model.uniqueId.count > 0) {
                        Button("Save") {
                            do {
                                try validateAndSave()
                            }
                            catch {
                                model.error = error
                            }
                        }
                    }
                }
            }
            .errorAlert(error: $model.error)
        }
    }
    
    func validateAndSave() throws {
        try model.validate()
        let activityType = model.asDBModel(context: self.dbContext)
        Task(priority: .high) {
            await saveAsync(at: activityType)
        }
    }
    
    func saveAsync(at: ActivityTypes) async {
        await self.dbContext.perform {
            do {
                try dbContext.save()
                dismiss()
            } catch {
                $model.error.wrappedValue = error
            }
        }
    }
}

struct AddActivityTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ManageActivityType()
    }
}
