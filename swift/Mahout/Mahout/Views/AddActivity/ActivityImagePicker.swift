//
//  ActivityImagePicker.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import SwiftUI
import PhotosUI

struct ActivityImagePicker: View {
    @StateObject var model: AddActivityModel
    
    let predefinedImages = ["noimage", "treadmill", "elliptical", "rowing", "walk"]
    
    var body: some View {
        HStack {
            Text("Select Image")
        }
        HStack {
            Picker("Image Type", selection: $model.imageType) {
                ForEach(["Predefined Image", "Custom Image"], id: \.self) {
                    Text($0)
                }
            }
            Spacer()
            if ($model.imageType.wrappedValue == "Predefined Image") {
                Picker("Image", selection: $model.selectedPredefinedImage) {
                    ForEach(predefinedImages, id: \.self) {
                        Text($0)
                    }
                }
            } else {
                PhotosPicker(selection: $model.selectedPictureItem, matching: .images) {
                    Label("Pick an image", systemImage: "photo")
                }.onChange(of: $model.selectedPictureItem.wrappedValue) { newItem in
                    Task {
                        do {
                            let data: Data = try await newItem!.loadTransferable(type: Data.self)!
                            $model.selectedImageData.wrappedValue = data
                            $model.selectedImage.wrappedValue = (UIImage(data: data)!)
                        } catch {
                            $model.selectedImage.wrappedValue = (UIImage())
                            $model.error.wrappedValue = error
                        }
                    }
                }
            }
        }
        HStack {
            Spacer()
            if ($model.imageType.wrappedValue == "Predefined Image") {
                Image(uiImage: UIImage(named: model.selectedPredefinedImage)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(0)
            }
            else {
                Image(uiImage: model.selectedImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(0)
            }
            Spacer()
        }
    }
}
