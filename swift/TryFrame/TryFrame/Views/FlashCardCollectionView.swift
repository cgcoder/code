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
    var reviewMode: Bool
    
    var body: some View {
        ZStack {
            (appState.currentFlipcardCollection?.getCardColor() ?? Color.gray).ignoresSafeArea()
            if appState.collectionPageLoadStatus == .done {
                FlashCardCollectionViewBody(reviewMode: reviewMode)
            }
            else if appState.collectionPageLoadStatus == .loading {
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "heart").foregroundColor(.white)
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
                Button("Start") {
                    appState.startCollection(contentMode: reviewMode ? .review : .ordered)
                    appState.navigationPath.append(appState.currentContent!)
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Button("Shuffle & Start") {
                    appState.startCollection(contentMode: reviewMode ? .shuffledReview : .shuffled)
                    appState.navigationPath.append(appState.currentContent!)
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
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
