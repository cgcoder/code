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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                withAnimation(.spring().repeatCount(1, autoreverses: true)) {
                    appState.updateFavorite(context: managedContext, collectionId: appState.currentFlipcardCollection!.id)
                }
            } label: {
                Image(systemName: self.appState.isFavorited ? "heart.fill" : "heart")
                    .foregroundColor(self.appState.isFavorited ? .red : .white)
                    .scaleEffect(self.appState.isFavorited ? 1.1 : 1.2)
            }
        }
    }
}

extension GlobalAppState {
    var isFavorited: Bool {
        return self.isFavorite(self.currentFlipcardCollection?.id ?? UUID())
    }
}


struct FlashCardCollectionViewBody: View {
    @EnvironmentObject var appState: GlobalAppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let reviewMode: Bool
    
    var body: some View {
        VStack {
            VStack {
                Text(appState.currentFlipcardCollection!.description).padding(20)
                if reviewMode {
                    Text("Let's review the questions you got wrong last time. Good luck!")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack {
                Button {
                    appState.startCollection(contentMode: reviewMode ? .review : .ordered)
                    appState.navigationPath.append(appState.currentContent!)
                } label: {
                    Text("Start")
                        .frame(width: 150)
                }
                .buttonStyle(RoundedRectButtonStyle(bgColor: Color("MyGreen")))
                .padding(.bottom, 20)
                
                Button {
                    appState.startCollection(contentMode: reviewMode ? .shuffledReview : .shuffled)
                    appState.navigationPath.append(appState.currentContent!)
                } label: {
                    Text("Shuffle & Start").frame(width: 150)
                }
                .buttonStyle(RoundedRectButtonStyle(bgColor: Color("MyGreen")))
                .padding(.bottom, 20)
                
                if !appState.currentFlipcardCollection!.isFlashCard {
                    Button {
                        appState.startCollection(contentMode: reviewMode ? .shuffledReview : .shuffled)
                        appState.navigationPath.append(appState.currentContent!)
                    } label: {
                        Text("Start Test").frame(width: 150)
                    }
                    .buttonStyle(RoundedRectButtonStyle(bgColor: Color("MyGreen")))
                    .padding(.bottom, 20)
                }
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
