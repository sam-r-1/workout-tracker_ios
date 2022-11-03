//
//  TemplateGridView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct TemplateGridView: View {
    let columnCount: Int = 2
    let templateData: TemplateData
    
    init(_ templateData: TemplateData) {
        self.templateData = templateData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(templateData.template.name)
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
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}

extension TemplateGridView {
    var exerciseList: some View {
        VStack(alignment: .leading) {
            ForEach(templateData.exercises.prefix(4)) { exercise in
                Text(exercise.name)
                    .font(.body)
                    .padding(.leading, 8)
            }
            
            if templateData.exercises.count == 5 {
                
                Text(templateData.exercises[4].name)
                    .font(.body)
                    .padding(.leading, 8)
                
            } else if templateData.exercises.count > 5 {
                
                Text("+ \(templateData.exercises.count - 4) more")
                    .font(.subheadline)
                    .padding(.leading, 16)
            }
        }
    }
}

//struct TemplateGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        TemplateGridView()
//    }
//}
