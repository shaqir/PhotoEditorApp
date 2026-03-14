//
//  PhotoRepository.swift
//  PhotoEditorApp
//
//  Created by Kostiantyn Kolosov on 17.06.2025.
//

import UIKit

final class PhotoRepositoryImpl: NSObject, PhotoRepository {
  private var completion: ((Result<Void, Error>) -> Void)?

  func saveToLibrary(photo: PhotoEntity) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      self.completion = { result in
        continuation.resume(with: result)
      }
      UIImageWriteToSavedPhotosAlbum(
        photo.image, self,
        #selector(saveImageCompletionHandler(_:didFinishSavingWithError:contextInfo:)), nil)
    }
  }

  @objc private func saveImageCompletionHandler(
    _ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?
  ) {
    if let error {
      completion?(.failure(error))
    } else {
      completion?(.success(()))
    }
    completion = nil
  }
}
