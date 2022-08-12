//
//  AddNewHeaderView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI


// Creates a page header and provides a "New" button. Used for header on Exercises, Templates
struct AddNewHeaderView: View {
    let title: String
    @Binding var showView: Bool
    let view: AnyView // the view to create a new object
    
    var body: some View {
        HStack {
            // page title
            Text(title)
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            //Button to add new exercise
            NavigationLink {
                view
            } label: {
                VStack {
                    Image(systemName: "plus")
                    Text("New")
                }
            }
            .foregroundColor(Color(.systemBlue))
        }
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
