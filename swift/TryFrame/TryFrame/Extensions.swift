//
//  Extensions.swift
//  TryFrame
//
//  Created by Gopinath chandrasekaran on 8/25/23.
//

import SwiftUI

enum SwipeDirection {
    case up, left, right, down
}

extension View {
    func onSwipeUpGesture(callback: @escaping (_ direction: SwipeDirection) -> Void) -> some View {
        self.gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                
                if abs(horizontalAmount) > abs(verticalAmount) {
                    callback(horizontalAmount < 0 ? .left : .right)
                } else {
                    callback(verticalAmount < 0 ? .up : .down)
                }
            })
    }
    
    func innerShadow<S: Shape, SS: ShapeStyle>(shape: S, color: SS, lineWidth: CGFloat = 1, offsetX: CGFloat = 0, offsetY: CGFloat = 0, blur: CGFloat = 4, blendMode: BlendMode = .normal, opacity: Double = 1) -> some View {
        return self.overlay {
            shape
                .stroke(color, lineWidth: lineWidth)
                .blendMode(blendMode)
                .offset(x: offsetX, y: offsetY)
                .blur(radius: 0)
                .mask(shape)
                .opacity(opacity)
        }
    }
}

/// https://stackoverflow.com/questions/68426768/swiftui-text-markdown-dynamic-string-not-working
extension String {
  func toMarkdown() -> AttributedString {
    do {
        return try AttributedString(markdown: self, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
    } catch {
      print("Error parsing Markdown for string \(self): \(error)")
      return AttributedString(self)
    }
  }
}
