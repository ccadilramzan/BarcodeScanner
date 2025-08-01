//
//  CameraPreviewView.swift
//  BarcodeScanner
//
//  Created by ADIL RAMZAN on 01/08/2025.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraPreviewView: UIViewRepresentable {
    var viewModel: ScannerViewModel // ✅ Just a plain var

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        viewModel.setPreviewLayer(on: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

//#Preview {
//    CameraPreviewView()
//}
