//
//  TemplateGridView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct TemplateGridView: View {
    @Environment(\.colorScheme) var colorScheme
    let columnCount: Int = 2
    let template: Template
    
    init(_ template: Template) {
        self.template = template
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(template.name)
                    .bold()
                .font(.title3)
                
                Spacer()
                
            }
            .foregroundColor(.primary)
            .padding(.trailing, 8)
            
            Divider()
            
            exerciseList
                .foregroundColor(.secondary)
            
            
        }
        .padding(8)
        .background(colorScheme == .light ? .white : Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        
    }
}

extension TemplateGridView {
    var exerciseList: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ForEach(1...min(template.exerciseNameList.count, 4), id: \.self) {
                    Text(template.exerciseNameList[$0 - 1])
                        .font(.body)
                        .padding(.leading, 8)
                }
                
                if template.exerciseNameList.count == 5 {
                    
                    Text(template.exerciseNameList[4])
                        .font(.body)
                        .padding(.leading, 8)
                    
                } else if template.exerciseNameList.count > 5 {
                    
                    Text("+ \(template.exerciseNameList.count - 4) more")
                        .font(.subheadline)
                        .padding(.leading, 16)
                }
            }
            
            // Blank text to provide constant height
            VStack {
                ForEach(1...5, id: \.self) { _ in
                    Text(" ")
                        .font(.body)
                }
            }
        }
    }
}

struct TemplateGridView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            TemplateGridView(MockService.sampleTemplates[0])
        }
    }
}
