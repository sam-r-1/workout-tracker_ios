//
//  RandomString.swift
//  workout_trackerTests
//
//  Created by Sam Rankin on 4/11/23.
//

import Foundation

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
      return String((0..<length).map{ _ in letters.randomElement()! })
}
