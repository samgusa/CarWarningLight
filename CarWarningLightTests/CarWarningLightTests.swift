//
//  CarWarningLightTests.swift
//  CarWarningLightTests
//
//  Created by Sam Greenhill on 5/19/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Testing
@testable import CarWarningLight
import SwiftUI
import XCTest


@Suite("ImageDetectionViewModel Tests")
struct ImageDetectionViewModelTests {

    @Test("Initial state should be correct")
    func testInitialState() {
        // Arrange
        let viewModel = ImageDetectionViewModel()

        // Assert
        XCTAssertTrue(viewModel.imageRecogResults.isEmpty)
        XCTAssertFalse(viewModel.showResults)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.isProcessing)
    }

    @Test("Processing invalid image should return failure")
    async func testProcessInvalidImage() async throws {
        // Arrange
        let viewModel = ImageDetectionViewModel()
        let invalidImage = UIImage()

        // Act
        let result = await viewModel.processImage(photo: invalidImage)

        // Assert
        XCTAssertEqual(result, .failed("Could not process the image"))
        XCTAssertEqual(viewModel.errorMessage, "Could not process the image")
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isProcessing)
    }

    @Test("Empty detection results should return failure")
    async func testEmptyDetectionResults() async throws {
        // Arrange
        let viewModel = ImageDetectionViewModel()

        // Create a test image that should yield no results
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Mock the detectAsync method to return empty results
        // In real tests, you might use dependency injection or a test-specific subclass
        let expectation = XCTestExpectation(description: "Detection completed")

        // Act
        let result = await viewModel.processImage(photo: testImage)

        // Assert
        XCTAssertEqual(result, .failed("No Symbols detected in the image"))
        XCTAssertEqual(viewModel.errorMessage, "No Symbols detected in the image")
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isProcessing)
    }

    // Note: Testing successful image recognition would typically require:
    // 1. Mock ML model
    // 2. Test-specific image with known outputs
    // 3. Dependency injection to avoid actual ML processing
    // This would be a more complex test implementation
}
