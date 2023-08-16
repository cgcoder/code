//
//  AddActivityTypeView.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//

import SwiftUI
import PhotosUI

func addSpacer(_ txt: String) -> some View {
    print("Change detected!!! \(txt)")
    return Spacer()
}

struct AddActivityTypeView: View {
    let predefinedImages = ["noimage", "treadmill", "elliptical", "rowing"]
    
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var model = AddActivityModel()
    
    var body: some View {
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
            Spacer()
        }
        .padding()
            .navigationTitle("Add Activity Type")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        validateAndSave()
                    }
                }
            }
            .errorAlert(error: $model.error)
    }
    
    func validateAndSave() {
        let info = model.inputInfo.trimmingCharacters(in: .whitespaces)
        let image = model.inputImage.trimmingCharacters(in: .whitespaces)
        let activityType = ActivityTypes(context: self.dbContext)
        activityType.info = info
        activityType.image = image
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
                print("Err")
            }
        }
    }
}

struct AddActivityTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityTypeView()
    }
}
