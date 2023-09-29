//
//  HomePageView.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/1/23.
//

import SwiftUI

struct Tile: View {
    let color: Int = Int.random(in: 1...4)
    let collection: FlipCardCollection
    
    var body: some View {
        NavigationLink(value: collection) {
            VStack(alignment: .leading) {
                Text(collection.name).font(.system(.callout)).foregroundStyle(Color.primary).multilineTextAlignment(.leading)
                Text(collection.description).lineLimit(2).fontWeight(.light).font(.system(.subheadline)).foregroundStyle(Color.secondary).multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(7)
            .padding([.top], 10)
            .frame(width: 200, height: 150, alignment: .leading)
            .background(self.collection.getCardColor())
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .innerShadow(shape: RoundedRectangle(cornerRadius: 5), color: .gray, lineWidth: 2)
        }
    }
}

struct HomePageView: View {
    @EnvironmentObject var appState: GlobalAppState
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Collections").font(.system(.title2))
                Spacer()
                Button {
                    
                }
                label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(appState.flipcardCollections, id: \.id) { collection in
                        Tile(collection: collection).padding([.leading], 5)
                    }
                }
            }
            .padding(.bottom, 10)
            
            Divider()
            Text("Favorites").font(.system(.title2))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(appState.favoriteCollections, id: \.id) { collection in
                        Tile(collection: collection).padding([.leading], 5)
                    }
                }
            }
            .padding(.bottom, 10)
            
            Divider()
            Text("Recently").font(.system(.title2))
            Spacer()
        }
        .navigationTitle("Welcome!")
        .navigationDestination(for: FlipCardCollection.self) { collection in
            FlashCardCollectionView(collectionId: collection.id, reviewMode: false)
        }
        .navigationDestination(for: FlipCardCollectionContent.self) { content in
            SwipeView()
        }
        .navigationDestination(for: NavAction.self) { navAction in
            switch navAction {
            case .collectionContentReview:
                FlashCardCollectionView(collectionId: nil, reviewMode: true)
            }
        }
        .onAppear {
            appState.initialize()
        }
    }
}

#Preview {
    HomePageView().environmentObject(GlobalAppState.appStateForPreview())
}
