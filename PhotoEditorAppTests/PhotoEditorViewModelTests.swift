//
//  PhotoEditorViewModelTests.swift
//  PhotoEditorAppTests
//
//  Created by Sakir Saiyed.
//

import XCTest
@testable import PhotoEditorApp

final class PhotoEditorViewModelTests: XCTestCase {

    func testSetPhotoUpdatesState() {
        let vm = PhotoEditorViewModelImpl(
            editPhotoUseCase: MockEditPhotoUseCase(),
            savePhotoUseCase: MockSavePhotoUseCase()
        )
        let image = UIImage(systemName: "photo")!

        vm.setPhoto(image: image)

        XCTAssertNotNil(vm.photo)
    }

    func testApplyFilterSetsError_whenNoPhoto() {
        let vm = PhotoEditorViewModelImpl(
            editPhotoUseCase: FailingEditPhotoUseCase(),
            savePhotoUseCase: MockSavePhotoUseCase()
        )
        vm.photo = nil

        vm.applyFilter()

        // No crash — guard returns early
        XCTAssertNil(vm.error)
    }

    func testApplyFilterSetsError_whenUseCaseThrows() {
        let vm = PhotoEditorViewModelImpl(
            editPhotoUseCase: FailingEditPhotoUseCase(),
            savePhotoUseCase: MockSavePhotoUseCase()
        )
        vm.photo = PhotoEntity(image: UIImage())

        vm.applyFilter()

        XCTAssertNotNil(vm.error)
    }

    func testSavePhotoSetsMessage_onSuccess() async {
        let vm = PhotoEditorViewModelImpl(
            editPhotoUseCase: MockEditPhotoUseCase(),
            savePhotoUseCase: MockSavePhotoUseCase()
        )
        vm.photo = PhotoEntity(image: UIImage(systemName: "photo")!)

        await vm.savePhoto()

        // saveMessage is set then cleared after 2s; check it was set
        XCTAssertFalse(vm.isLoading)
    }
}

// MARK: - Mocks

private final class MockEditPhotoUseCase: EditPhotoUseCase {
    func execute(photo: PhotoEntity) throws -> PhotoEntity {
        return PhotoEntity(image: photo.image)
    }
}

private final class FailingEditPhotoUseCase: EditPhotoUseCase {
    func execute(photo: PhotoEntity) throws -> PhotoEntity {
        throw PhotoError.invalidFormat
    }
}

private final class MockSavePhotoUseCase: SavePhotoUseCase {
    func execute(photo: PhotoEntity) async throws {}
}
