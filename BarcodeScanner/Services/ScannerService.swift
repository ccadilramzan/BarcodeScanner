//
//  ScannerService.swift
//  BarcodeScanner
//
//  Created by ADIL RAMZAN on 01/08/2025.
//

import AVFoundation
import UIKit

protocol ScannerServiceDelegate: AnyObject {
    func didFindBarcode(_ code: String)
    func didFail(with error: ScannerError)
}

class ScannerService: NSObject {
    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?

    weak var delegate: ScannerServiceDelegate?

    func startSession() throws {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            throw ScannerError.cameraUnavailable
        }

        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            throw ScannerError.permissionDenied
        }

        session.beginConfiguration()

        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            session.commitConfiguration()
            throw ScannerError.configurationFailed
        }

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .qr, .code128]
        } else {
            session.commitConfiguration()
            throw ScannerError.configurationFailed
        }

        session.commitConfiguration()
        session.startRunning()
    }

    func stopSession() {
        session.stopRunning()
    }

    func setPreviewLayer(on view: UIView) {
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
        }

        previewLayer?.frame = view.bounds

        if let layer = previewLayer, layer.superlayer == nil {
            view.layer.insertSublayer(layer, at: 0)
        }
    }

}

extension ScannerService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = metadataObject.stringValue else {
            return
        }

        delegate?.didFindBarcode(code)
    }
}

