//
//  ActivitySettingView.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import SwiftUI

struct ActivitySettingView: View {
    
    @StateObject var model: AddActivityModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Toggle(isOn: $model.isInclinationBased) {
                    Text("Inclination")
                }
            }
            HStack {
                Toggle(isOn: $model.isTensionBased) {
                    Text("Tension")
                }
            }
            HStack {
                Toggle(isOn: $model.isFrictionBased) {
                    Text("Friction")
                }
            }
            HStack {
                Toggle(isOn: $model.isLapBased) {
                    Text("Laps/Repeats")
                }
            }
            HStack {
                Toggle(isOn: $model.isKgWeightBased) {
                    Text("Weight (Kg)")
                }
            }
            HStack {
                Toggle(isOn: $model.isLBWeightBased) {
                    Text("Weight (Lb)")
                }
            }
            HStack {
                Toggle(isOn: $model.isMilesBased) {
                    Text("Distance (Miles)")
                }
            }
            HStack {
                Toggle(isOn: $model.isKmBased) {
                    Text("Distance (KM)")
                }
            }
            HStack {
                Toggle(isOn: $model.isFloorsBased) {
                    Text("Floors")
                }
            }
            HStack {
                Toggle(isOn: $model.isDurationBased) {
                    Text("Duration (min)")
                }
            }
        }
    }
}
