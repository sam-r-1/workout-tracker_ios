//
//  ExercisesViewModelTests.swift
//  workout_trackerTests
//
//  Created by Sam Rankin on 8/10/22.
//

import XCTest
@testable import Workout_Tracker

@MainActor
class ExercisesViewModelTests: XCTestCase {
    
    private var vm: ExercisesView.ViewModel?

    override func setUpWithError() throws {
        vm = ExercisesView.ViewModel(exerciseService: StubExerciseService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    // MARK: - Variables
    func test_ExercisesViewModel_loadingState_shouldStartInLoading() {
        // Given
        guard let vm else { XCTFail(); return }
        
        // Then
        XCTAssertEqual(vm.loadingState, LoadingState.loading)
    }
    
    func test_ExercisesViewModel_searchText_shouldStartEmpty() {
        // Given
        guard let vm else { XCTFail(); return }
        
        // Then
        XCTAssertEqual(vm.searchText, "")
    }

    func test_ExercisesViewModel_exercises_shouldStartEmpty() {
        // Given
        guard let vm else { XCTFail(); return }
        
        // Then
        XCTAssert(vm.exercises.isEmpty)
    }
    
    
    // MARK: - Functions
    func test_ExercisesViewModel_fetchExercises_shouldSetLoadingStateToDataOnSuccess() async {
        // Given
        guard let vm else { XCTFail(); return }
        
        // When
        await vm.fetchExercises()
        
        // Then
        XCTAssertEqual(vm.loadingState, LoadingState.data)
    }
    
    func test_ExercisesViewModel_fetchExercises_shouldSetExercises() async {
        // Given
        guard let vm else { XCTFail(); return }
        
        // When
        await vm.fetchExercises()
        
        // Then
        XCTAssert(!vm.exercises.isEmpty)
    }

}
