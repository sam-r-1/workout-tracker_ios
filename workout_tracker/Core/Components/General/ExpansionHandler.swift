//
//  ExpansionHandler.swift
//  workout_tracker
//
//  Created by Sam Rankin on 1/24/23.
//

import SwiftUI

@MainActor
class ExpansionHandler<T: Equatable>: ObservableObject {
    @Published private (set) var expandedItem: T?
    
    func isExpanded(_ item: T) -> Binding<Bool> {
        return Binding(
            get: { item == self.expandedItem },
            set: { self.expandedItem = $0 == true ? item : nil }
        )
    }
    
    func toggleExpanded(for item: T) {
        self.expandedItem = self.expandedItem == item ? nil : item
    }
}
