//
//  AddActivityModel.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//


import PhotosUI
import SwiftUI

final class AddActivityModel: ObservableObject {
    @Published var name: String = ""
    @Published var inputInfo: String = ""
    @Published var inputImage: String = ""
    @Published var imageType: String = "Predefined Image"
    @Published var selectedPredefinedImage: String = "treadmill"
    @Published var selectedPictureItem: PhotosPickerItem? = nil
    @Published var error: Error? = nil
    @Published var selectedImage: UIImage?
}
