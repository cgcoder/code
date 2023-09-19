//
//  FlashCardState.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 9/1/23.
//

import SwiftUI

class FlashCardState: ObservableObject {
    var resetViewOnFlip: Bool
    var maxTimeTick = 30
    var colorOption: Int
    @Published var showBack: Bool = false
    @Published var id: Int = 0
    @Published var isProgressing: Bool = true
    @Published var progress: CGFloat = 0.0
    @Published var timerTick: Int = 0
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(resetViewOnFlip: Bool = false) {
        self.resetViewOnFlip = resetViewOnFlip
        colorOption = Int.random(in: 1...4)
    }
        
    func clockTick() {
        // self.timerTick += 1
        // print("Tick \(self.timerTick)")
        if (timerTick == 30) {
            timer.upstream.connect().cancel()
        }
    }
    
    func flip() {
        if self.resetViewOnFlip {
            if !self.showBack {
                var transaction = Transaction(animation: .linear(duration: 0).delay(1))
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    progress = 0
                }
                
                withAnimation(.linear(duration: 30)) {
                    self.progress = .infinity
                }
            }
        }
        withAnimation {
            self.showBack.toggle()
        }
    }
    
    func animateProgress() {
        withAnimation(.linear(duration: 30)) {
            self.progress = .infinity
        }
    }
}
