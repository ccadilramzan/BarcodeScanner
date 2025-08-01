//
//  ScannerError.swift
//  BarcodeScanner
//
//  Created by ADIL RAMZAN on 01/08/2025.
//

import Foundation

enum ScannerError: Error, LocalizedError {
    case cameraUnavailable
    case permissionDenied
    case configurationFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Camera is unavailable on this device."
        case .permissionDenied:
            return "Camera access was denied."
        case .configurationFailed:
            return "Failed to configure the camera."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

