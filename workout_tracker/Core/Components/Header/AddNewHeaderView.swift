//
//  AddNewHeaderView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI


// Creates a page header and provides a "New" button. Used for header on Exercises, Templates
struct AddNewHeaderView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    let title: String
    @Binding var showView: Bool
    let view: AnyView // the view to create a new object
    
    var body: some View {
        Group {
            // page title
            Text(title)
                .font(.largeTitle)
                .bold()
            
            if !sizeCategory.isAccessibilityCategory { Spacer() }
            
            //Button to add new exercise
            NavigationLink {
                view
            } label: {
                Group {
                    Image(systemName: "plus")
                    Text("New")
                }
                .embedInStack(reversed: true)
            }
            .foregroundColor(Color(.systemBlue))
        }
        .embedInStack()
        .padding([.top, .horizontal])
    }
}

struct AddNewHeaderView_Previews: PreviewProvider {
    @State static var isShowing = false
    static var previews: some View {
        AddNewHeaderView(title: "My Templates",
                         showView: $isShowing,
                         view: AnyView(Text("New view goes here")))
    }
}
