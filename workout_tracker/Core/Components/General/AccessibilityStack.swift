//
//  AccessibilityStack.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/27/22.
//

import SwiftUI

fileprivate struct EmbedInStack: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var reversed: Bool
    var vStackThreshold: ContentSizeCategory
    var spacing: CGFloat?
    
    init(reversed: Bool, verticalIfLargerThan: ContentSizeCategory, spacing: CGFloat?) {
        self.reversed = reversed
        self.vStackThreshold = verticalIfLargerThan
        self.spacing = spacing
    }

    func body(content: Content) -> some View {
        Group {
            if (sizeCategory > vStackThreshold) != (reversed) {
                VStack(spacing: spacing) { content }
            } else {
                HStack(spacing: spacing) { content }
            }
        }
    }
}

extension Group where Content: View {
    func embedInStack(reversed: Bool = false, verticalIfLargerThan vStackThreshold: ContentSizeCategory = .extraExtraExtraLarge, spacing: CGFloat? = nil) -> some View {
        modifier(EmbedInStack(reversed: reversed, verticalIfLargerThan: vStackThreshold, spacing: spacing))
    }
}
