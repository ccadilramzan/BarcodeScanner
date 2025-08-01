//
//  ScannerViewModel.swift
//  BarcodeScanner
//
//  Created by ADIL RAMZAN on 01/08/2025.
//

import Foundation
import AVFoundation
import UIKit

class ScannerViewModel: NSObject, ObservableObject {
    @Published var scannedCode: String?
    @Published var error: ScannerError?

    private let scannerService = ScannerService()

    override init() {
        super.init()
        scannerService.delegate = self
    }

    func startSession() {
        do {
            try scannerService.startSession()
        } catch let err as ScannerError {
            self.error = err
        } catch {
            self.error = .unknown
        }
    }

    func stopSession() {
        scannerService.stopSession()
    }

    func restartSession() {
        self.error = nil
        self.scannedCode = nil
        startSession()
    }

    func setPreviewLayer(on view: UIView) {
        scannerService.setPreviewLayer(on: view)
    }

    /// ✅ Called when ScannerViewModel is deallocated
    deinit {
        stopSession()
    }
}

extension ScannerViewModel: ScannerServiceDelegate {
    func didFindBarcode(_ code: String) {
        DispatchQueue.main.async {
            self.scannedCode = code
            self.stopSession()
        }
    }

    func didFail(with error: ScannerError) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
}
