//
//  FlipCardCollectionView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/16/23.
//

import SwiftUI

struct FlipCardCollectionView: View {
    
    var collectionId: UUID
    @EnvironmentObject var appState: GlobalAppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            if appState.collectionPageLoadStatus == .done {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: SwipeView()) {
                            Text("Start")
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                        NavigationLink(destination: SwipeView(shuffled: true)) {
                            Text("Shuffle & Start")
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
                Text(appState.currentFlipCardCollection!.description)
            }
            else if appState.collectionPageLoadStatus == .loading {
                Text("loading...")
            }
            else {
                Text("Error loading this collection.")
            }
        }
        .onAppear {
            self.appState.loadFlipCardCollection(collectionId: collectionId)
        }
        .navigationTitle(appState.currentFlipCardCollection?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    FlipCardCollectionView(collectionId: UUID(uuidString: "7184ff79-8f91-4dd5-982f-7d005cc703f5")!)
        .environmentObject(GlobalAppState.appStateForPreview())
}
