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
    
    init(reversed: Bool, verticalIfLargerThan: ContentSizeCategory) {
        self.reversed = reversed
        self.vStackThreshold = verticalIfLargerThan
    }

    func body(content: Content) -> some View {
        Group {
            if (sizeCategory > vStackThreshold) != (reversed) {
                VStack { content }
            } else {
                HStack { content }
            }
        }
    }
}

extension Group where Content: View {
    func embedInStack(reversed: Bool = false, verticalIfLargerThan vStackThreshold: ContentSizeCategory = .extraExtraExtraLarge) -> some View {
        modifier(EmbedInStack(reversed: reversed, verticalIfLargerThan: vStackThreshold))
    }
}
