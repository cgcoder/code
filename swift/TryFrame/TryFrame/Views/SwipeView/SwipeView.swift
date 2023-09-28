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
    @EnvironmentObject var appState: GlobalAppState

    var body: some View {
        ZStack {
            if (appState.collectionStatus == .progress) {
                ForEach(appState.currentContent!.questions, id: \.id) { question in
                    if (appState.isCurrentQuestion(id: question.id)) {
                        FlashCardView(
                            backgroundColor: appState.currentFlipcardCollection?.getCardColor())
                        .transition(.asymmetric(insertion: .move(edge: appState.nextQuestionMode == .up ? .bottom : .top).combined(with: .opacity), removal: .scale))
                    }
                }
            }
            else if (appState.collectionStatus == .complete) {
                CompletedCollectionView()
            }
        }
        .navigationTitle(appState.currentFlipcardCollection!.name)
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onSwipeUpGesture { direction in
            withAnimation {
                if (direction == .up) {
                    appState.nextQuestion()
                }
                else if (direction == .down) {
                    appState.prevQuestion()
                }
            }
        }
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView().environmentObject(GlobalAppState.appStateForPreview())
    }
}
