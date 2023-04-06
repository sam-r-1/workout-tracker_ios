//
//  workout_trackerTests.swift
//  workout_trackerTests
//
//  Created by Sam Rankin on 8/10/22.
//

import XCTest
@testable import Workout_Tracker

@MainActor
class ExercisesViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ExercisesViewModel_loadingState_shouldStartInLoading() throws {
        // Given
        let vm = ExercisesView.ViewModel(exerciseService: StubExerciseService())
        
        // Then
        XCTAssertEqual(vm.loadingState, LoadingState.loading)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
