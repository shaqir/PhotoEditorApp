//
//  EditPhotoUseCaseTests.swift
//  PhotoEditorAppTests
//
//  Created by Sakir Saiyed.
//

import XCTest
@testable import PhotoEditorApp

final class EditPhotoUseCaseTests: XCTestCase {

    private var sut: EditPhotoUseCaseImpl!

    override func setUp() {
        super.setUp()
        sut = EditPhotoUseCaseImpl(photoRepository: MockPhotoRepository())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testApplyFilterReturnsFilteredPhoto() throws {
        let image = UIImage(systemName: "photo")!
        let entity = PhotoEntity(image: image)

        let result = try sut.execute(photo: entity)

        XCTAssertNotEqual(result.id, entity.id, "Filtered photo should be a new entity")
    }

    func testApplyFilterToEmptyImageThrowsInvalidFormat() {
        // An empty UIImage has no CGImage backing — CIImage init returns nil
        let empty = UIImage()
        let entity = PhotoEntity(image: empty)

        XCTAssertThrowsError(try sut.execute(photo: entity)) { error in
            XCTAssertEqual(error as? PhotoError, .invalidFormat)
        }
    }
}

// MARK: - Mock

private final class MockPhotoRepository: PhotoRepository {
    func saveToLibrary(photo: PhotoEntity) async throws {}
}
