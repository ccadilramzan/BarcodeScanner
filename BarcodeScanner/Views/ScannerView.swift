//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by ADIL RAMZAN on 01/08/2025.
//

import SwiftUI

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()

    var body: some View {
        ZStack {
            CameraPreviewView(viewModel: viewModel)

            if let error = viewModel.error {
                VStack {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                    Button("Try Again") {
                        viewModel.restartSession()
                    }
                    .padding(.top, 10)
                }
                .padding()
            }

            if let scannedCode = viewModel.scannedCode {
                VStack {
                    Text("Scanned: \(scannedCode)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}


#Preview {
    ScannerView()
}
