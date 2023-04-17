//
//  ExercisesViewModelTests.swift
//  workout_trackerTests
//
//  Created by Sam Rankin on 8/10/22.
//

import XCTest
@testable import Workout_Tracker

@MainActor
final class ExercisesViewModelTests: XCTestCase {
    
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
    
    func test_ExercisesViewModel_searchableExercises_shouldFilterExercises() async {
        // Given
        guard let vm else { XCTFail(); return }
        await vm.fetchExercises()
        
        for _ in 1...50 {
            // When
            vm.searchText = randomString(length: 1)
            let query = vm.searchText.lowercased()
            
            // Then
            for exercise in vm.searchableExercises {
                XCTAssert(exercise.name.lowercased().contains(query) || exercise.type.lowercased().contains(query))
            }
            
            XCTAssert(vm.searchableExercises.count <= vm.exercises.count)
        }
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
    
    func test_ExercisesViewModel_fetchExercises_shouldCatchError() async {
        // Given
        let errorVM = ExercisesView.ViewModel(exerciseService: ErrorStubExerciseService())
        
        // When
        await errorVM.fetchExercises()
        
        // Then
        XCTAssertEqual(errorVM.loadingState, LoadingState.error)
        XCTAssert(errorVM.exercises.isEmpty)
    }

}
