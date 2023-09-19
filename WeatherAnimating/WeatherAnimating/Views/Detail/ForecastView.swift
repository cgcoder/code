//
//  ForecastView.swift
//  WeatherAnimating
//
//  Created by Gopinath chandrasekaran on 8/23/23.
//

import SwiftUI

struct ForecastView: View {
    @State var text: String = ""
    var body: some View {
        ScrollView {
            VStack {
                
            }
            .padding(30)
            .frame(maxWidth: .infinity)
        }
        .backgroundBlur(radius: 25, opaque: true)
        .background(Color.bottomSheetBackground)
        .clipShape(RoundedRectangle(cornerRadius: 44))
        .innerShadow(shape: RoundedRectangle(cornerRadius: 44), color: Color.bottomSheetBorderMiddle, lineWidth: 1, offsetX: 0, offsetY: 1, opacity: 1)
        .overlay {
            Divider().blendMode(.overlay)
                .background(Color.bottomSheetBorderTop)
                .frame(maxHeight: .infinity, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 44))
        }
        .overlay {
            // MARK: Drag indicator
            VStack() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black.opacity(0.3))
                    .frame(maxWidth: 28, maxHeight: 5, alignment: .top)
                    .padding(.top, 5)
                Spacer()
            }
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView().background(Color.background).preferredColorScheme(.dark)
    }
}
