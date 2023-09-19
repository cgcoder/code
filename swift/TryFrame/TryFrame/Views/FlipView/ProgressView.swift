//
//  ProgressView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/25/23.
//

import SwiftUI

struct ProgressView: View {
    
    @ObservedObject var state: FlashCardState
    @State var progressColor: Color = .white
    var duration: Double = 30
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 3)
                .fill(.green)
                .frame(height: 6, alignment: .leading)
            RoundedRectangle(cornerRadius: 3)
                .fill(progressColor)
                .frame(width: state.progress, height: 6, alignment: .leading)
        }
        .frame(maxHeight: 6)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(state: FlashCardState())
    }
}
