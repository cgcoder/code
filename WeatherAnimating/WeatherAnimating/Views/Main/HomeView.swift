//
//  HomeView.swift
//  WeatherAnimating
//
//  Created by Gopinath chandrasekaran on 8/23/23.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83
    case middle = 0.385
}

struct HomeView: View {
    
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var isPresented: Bool = true
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()
                Image("Background").resizable().ignoresSafeArea()
                Image("House").frame(maxHeight: .infinity, alignment: .top).padding(.top, 257)
                VStack(spacing: -10) {
                    Text("Seattle").font(.largeTitle).foregroundColor(Color.white)
                    VStack {
                        Text(attributedString)
                        Text("H: 24° |  L: 18°").font(.title3.weight(.semibold))
                    }
                    Spacer()
                }
                .padding(.top, 51)
                // MARK: Bottom sheet
                BottomSheetView(position: $bottomSheetPosition) {
                    Text(bottomSheetPosition.rawValue.formatted())
                } content: {
                    ForecastView()
                }
                // MARK: Tab Bar
                TabBar(action: {
                    bottomSheetPosition = .top
                })
            }
        }.navigationBarHidden(true)
    }
    
    private var attributedString: AttributedString {
        var string = AttributedString("19°\n Mostly Clear")
        if let temp = string.range(of: "19°") {
            string[temp].font = .system(size: 96, weight: .thin)
            string[temp].foregroundColor = .primary
        }
        if let pipe = string.range(of: " | ") {
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .secondary
        }
        if let weather = string.range(of: "Mostly Clear") {
            string[weather].font = .title3.weight(.semibold)
            string[weather].foregroundColor = .secondary
        }
        return string
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().preferredColorScheme(.dark)
    }
}
