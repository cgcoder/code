//
//  FlipCardCollectionView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/16/23.
//

import SwiftUI

struct FlashCardCollectionView: View {
    
    var collectionId: UUID?
    @EnvironmentObject var appState: GlobalAppState
    @Environment(\.managedObjectContext) var managedContext
    
    var reviewMode: Bool
    
    var body: some View {
        ZStack {
            (appState.currentFlipcardCollection?.getCardColor() ?? Color.gray).ignoresSafeArea()
            if appState.collectionPageLoadStatus == .done {
                FlashCardCollectionViewBody(reviewMode: reviewMode)
            }
            else if appState.collectionPageLoadStatus == .progress {
                Text("loading...")
            }
            else {
                Text("Error loading this collection.")
            }
        }
        .onAppear {
            if (!reviewMode) {
                self.appState.loadFlipCardCollection(collectionId: collectionId!)
            }
        }
        .navigationTitle("\(appState.currentFlipcardCollection?.name ?? "")\(reviewMode ? " - Review" : "")")
        .toolbar {
            Button {
                appState.updateFavorite(context: managedContext, collectionId: appState.currentFlipcardCollection!.id)
            } label: {
                Image(systemName: self.appState.isFavorite(self.appState.currentFlipcardCollection?.id ?? UUID()) ? "heart.fill" : "heart").foregroundColor(.white)
            }
        }
    }
}

struct FlashCardCollectionViewBody: View {
    @EnvironmentObject var appState: GlobalAppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let reviewMode: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text(appState.currentFlipcardCollection!.description)
            if reviewMode {
                Text("Let's review the questions you got wrong last time. Good luck!")
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    appState.startCollection(contentMode: reviewMode ? .review : .ordered)
                    appState.navigationPath.append(appState.currentContent!)
                } label: {
                    Image(systemName: "play.circle").foregroundStyle(.white)
                        .imageScale(.large)
                }
                .buttonStyle(NeumorphicButtonStyle(bgColor: .green))
                
                Spacer()
                Button {
                    appState.startCollection(contentMode: reviewMode ? .shuffledReview : .shuffled)
                    appState.navigationPath.append(appState.currentContent!)
                } label: {
                    Image(systemName: "shuffle.circle").foregroundStyle(.white)
                        .imageScale(.large)
                }
                .buttonStyle(NeumorphicButtonStyle(bgColor: .green))
                Spacer()
            }
            .padding(20)
            .padding([.bottom], 40)
        }
    }
}

#Preview {
    FlashCardCollectionView(collectionId: UUID(uuidString: "7184ff79-8f91-4dd5-982f-7d005cc703f5")!, reviewMode: false)
        .environmentObject(GlobalAppState.appStateForPreview())
}