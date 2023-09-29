//
//  CompletedCollectionView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/23/23.
//

import SwiftUI

struct CompletedCollectionView: View {
    @EnvironmentObject var appState: GlobalAppState
    @State var navTo: String? = ""
    @State var opacity: CGFloat = 0
    @State var opacity2: CGFloat = 0
    @State var opacity3: CGFloat = 0
    @State var opacity4: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack {
                Text("Congratulation! You have successfully completed this flash card collection. Now let's review how you have performed.").padding(.bottom, 20)
                
                Text("Total Questions \(appState.currentContent?.questions.count ?? 0)")
                    .font(.system(size: 32))
                    .opacity(opacity)
                    .padding(.bottom)
                Text("Correct \(appState.correctlyAnsweredCount)")
                    .font(.system(size: 30))
                    .opacity(opacity2)
                    .padding(.bottom)
                Text("Skipped \(appState.unAnsweredCount)")
                    .padding(.bottom)
                    .font(.system(size: 30))
                    .opacity(opacity3)
                Text("Incorrect \(appState.wronglyAnsweredCount)").padding(.bottom, 20)
                    .padding(.bottom)
                    .font(.system(size: 30))
                    .opacity(opacity4)
                
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        appState.navigationPath = NavigationPath()
                    } label: {
                           Image(systemName: "homekit").foregroundStyle(.white)
                            .imageScale(.large)
                        }
                        .buttonStyle(NeumorphicButtonStyle(bgColor: .green))
                    Spacer()
                    Button {
                        appState.restartCollection()
                        appState.navigationPath.removeLast(2)
                        appState.navigationPath.append(self.appState.currentFlipcardCollection!)
                    } label: {
                           Image(systemName: "repeat.circle").foregroundStyle(.white)
                            .imageScale(.large)
                        }
                        .buttonStyle(NeumorphicButtonStyle(bgColor: .red))
                    if (appState.wronglyAnsweredCount != 0 || appState.unAnsweredCount != 0) {
                        Spacer()
                        Button {
                            appState.navigationPath.removeLast(2)
                            appState.navigationPath.append(NavAction.collectionContentReview)
                        } label: {
                            Image(systemName: "arrow.uturn.forward.circle").foregroundStyle(.white)
                                .imageScale(.large)
                        }
                        .buttonStyle(NeumorphicButtonStyle(bgColor: .orange))
                    }
                    Spacer()
                }
            }
            VStack {
                CelebrateView().opacity(self.opacity4)
            }
        }
        .padding()
        .navigationTitle(appState.currentFlipcardCollection!.name)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appState.currentFlipcardCollection!.getCardColor())
        .onAppear {
            withAnimation(.spring(duration: 1)) {
                self.opacity = 1.0
            }
            withAnimation(.spring(duration: 1).delay(1)) {
                self.opacity2 = 1.0
            }
            withAnimation(.spring(duration: 1).delay(2)) {
                self.opacity3 = 1.0
            }
            withAnimation(.spring(duration: 1).delay(3)) {
                self.opacity4 = 1.0
            }
        }
    }
}

struct CelebrateView: View {
    @State var opacity = 1.0
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(1...100, id: \.self) { id in
                    Image(systemName: "star.fill").id(id)
                        .rotationEffect(.degrees(opacity == 1.0 ? 0.0 : 360.0))
                        .foregroundStyle(.yellow)
                        .position(x: Double.random(in: 1...proxy.size.width), y: Double.random(in: 1...proxy.size.height))
                        .opacity(opacity)
                        .animation(.spring(duration: 3).delay(3), value: opacity)
                }
            }
        }
        .onAppear {
            self.opacity = 0
        }
    }
}

struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    Circle()
                        .shadow(color: .white, radius: configuration.isPressed ? 2: 4, x: configuration.isPressed ? -1: -5, y: configuration.isPressed ? -1: -5)
                        .shadow(color: .black, radius: configuration.isPressed ? 2: 4, x: configuration.isPressed ? 1: 5, y: configuration.isPressed ? 1: 5)
                        .blendMode(.overlay)
                    Circle()
                        .fill(bgColor)
                }
        )
        .scaleEffect(configuration.isPressed ? 0.95: 1)
        .foregroundColor(.primary)
        .animation(.spring(duration: 0.25), value: configuration.isPressed)
    }
}

#Preview {
    CompletedCollectionView().environmentObject(GlobalAppState.appStateForPreviewMultichoice())
}
