//
//  MockService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/1/22.
//

import Foundation
import Firebase

enum MockService {
    static var sampleExercises: [Exercise] {
        [
            Exercise(uid: "", name: "Leg Press", type: "Legs", details: "Setting #4", includeWeight: true, includeReps: true, includeTime: true),
            Exercise(uid: "", name: "Pull-ups", type: "Upper-body", details: "", includeWeight: false, includeReps: true, includeTime: false),
            Exercise(uid: "", name: "Chest Press", type: "Upper-body", details: "Setting #2", includeWeight: true, includeReps: true, includeTime: true),
        ]
    }
    
    static var sampleInstances: [ExerciseInstance] {
        let range = 0..<10
        return range.map({ ExerciseInstance(uid: "", exerciseId: "", timestamp: Timestamp(date: Date(timeIntervalSinceNow: -2 * 86400 * Double($0))), reps: 5, time: 100 + Double.random(in: -12...12), weight: Double.random(in: (100 - 2 * Double($0))..<(140 - 2 * Double($0)))) })
    }
    
    static var sampleTemplates: [Template] {
        [
            Template(uid: "", name: "Preview", exerciseIdList: ["", "", "", "", "", ""], exerciseNameList: ["Push-ups", "Pull-ups", "Chest Press", "Leg Press", "Squats", "Plank"]),
            Template(uid: "", name: "Preview", exerciseIdList: ["", "", "", "", "", ""], exerciseNameList: ["Push-ups", "Pull-ups", "Chest Press", "Leg Press", "Squats", "Plank"]),
            Template(uid: "", name: "Preview", exerciseIdList: ["", "", "", "", "", ""], exerciseNameList: ["Push-ups", "Pull-ups", "Chest Press", "Leg Press", "Squats", "Plank"]),
            Template(uid: "", name: "Preview", exerciseIdList: ["", "", "", "", "", ""], exerciseNameList: ["Push-ups", "Pull-ups", "Chest Press", "Leg Press", "Squats", "Plank"]),
            Template(uid: "", name: "Preview", exerciseIdList: ["", "", "", "", "", ""], exerciseNameList: ["Push-ups", "Pull-ups", "Chest Press", "Leg Press", "Squats", "Plank"]),
        ]
    }
    
    static var sampleWorkouts: [Workout] {
        [
            Workout(uid: "", timestamp: Timestamp(date: Date.now), exerciseInstanceIdList: ["", "", "", "", ""])
        ]
    }
}
