//
//  InvertAppIcons.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/11/22.
//

import SwiftUI

struct DetectThemeChange: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let condition: Bool

    func body(content: Content) -> some View {
        
        if(colorScheme == .dark && condition) {
            content.colorInvert()
        } else {
            content
        }
    }
}

extension View {
    func invertOnDarkTheme(_ condition: Bool) -> some View {
        modifier(DetectThemeChange(condition: condition))
    }
}
