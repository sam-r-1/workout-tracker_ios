//
//  TemplatesViewModelTests.swift
//  workout_trackerTests
//
//  Created by Sam Rankin on 4/17/23.
//

import XCTest
@testable import Workout_Tracker

@MainActor
final class TemplatesViewModelTests: XCTestCase {
    
    private var vm: TemplatesView.ViewModel?

    override func setUpWithError() throws {
        vm = TemplatesView.ViewModel(templateService: StubTemplateService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

// MARK: - Variables
    func test_TemplatesViewModel_loadingState_shouldStartInLoading() {
        // Given
        guard let vm else { XCTFail(); return }
        
        // Then
        XCTAssertEqual(vm.loadingState, LoadingState.loading)
    }
    
    func test_TemplatesViewModel_searchText_shouldStartEmpty() {
        // Given
        guard let vm else { XCTFail(); return }
        
        // Then
        XCTAssertEqual(vm.searchText, "")
    }

    func test_TemplatesViewModel_templates_shouldStartEmpty() {
        // Given
        guard let vm else { XCTFail(); return }
        
        // Then
        XCTAssert(vm.templates.isEmpty)
    }
    
    func test_TemplatesViewModel_searchableTemplates_shouldFilterTemplates() async {
        // Given
        guard let vm else { XCTFail(); return }
        await vm.fetchTemplates()
        
        for _ in 1...50 {
            // When
            vm.searchText = randomString(length: 1)
            let query = vm.searchText.lowercased()
            
            // Then
            for template in vm.searchableTemplates {
                XCTAssert(template.name.lowercased().contains(query))
            }
            
            XCTAssert(vm.searchableTemplates.count <= vm.templates.count)
        }
    }

}
