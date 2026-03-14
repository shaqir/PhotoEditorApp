//
//  PhotoError.swift
//  PhotoEditorApp
//
//  Created by Kostiantyn Kolosov on 17.06.2025.
//

import Foundation

/// Domain errors for photo editing and save operations.
enum PhotoError: Error, LocalizedError {
  /// No photo has been selected by the user.
  case noPhoto
  /// Photo could not be converted to a CIImage for filtering.
  case invalidFormat
  /// An unrecoverable internal error occurred.
  case unknown
  /// Photo library write failed (permissions or disk).
  case saveFailed

  var errorDescription: String? {
    switch self {
    case .noPhoto: return "No photo selected."
    case .invalidFormat: return "Invalid photo format."
    case .unknown: return "Unknown error."
    case .saveFailed: return "Failed to save photo."
    }
  }
}
