//
//  SwiftUIView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/25/23.
//

import SwiftUI

class SwipeState: ObservableObject {
    
}

struct SwipeView: View {
    var shuffled: Bool = false
    @EnvironmentObject var appState: GlobalAppState
    @State var state: SwipeDirection = .up

    var body: some View {
        ZStack {
            ForEach(appState.getQuestions(shuffled: shuffled), id: \.id) { question in
                if (appState.isCurrentQuestion(shuffled: shuffled, id: question.id)) {
                    FlashCardView(question: question).transition(.asymmetric(insertion: .move(edge: state == .up ? .bottom : .top), removal: .scale))
                }
            }
        }
        .navigationTitle(appState.currentFlipCardCollection!.name)
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onSwipeUpGesture { direction in
            withAnimation {
                if (direction == .up) {
                    state = .up
                    appState.nextQuestion()
                }
                else if (direction == .down) {
                    state = .down
                    appState.prevQuestion()
                }
            }
        }
        .onAppear {
            appState.setShuffleMode(self.shuffled)
        }
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView().environmentObject(GlobalAppState.appStateForPreview())
    }
}
