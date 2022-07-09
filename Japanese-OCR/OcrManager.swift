//
//  OcrManager.swift
//  Japanese-OCR
//
//  Created by NakaokaRei on 2022/06/10.
//

import Foundation
import Vision
import Combine
import UIKit

class OcrManager: ObservableObject {
    let videoCapture = VideoCapture()
    @Published var buffImage: UIImage? = nil
    @Published var recognizedText: String = ""
    
    
    init() {
        runVideo()
    }
    
    func recognizeText(sampleBuffer: CMSampleBuffer) {
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let maximumCandidates = 1
            self.recognizedText = ""
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.recognizedText += candidate.string
            }
            print(self.recognizedText)
        }
        request.recognitionLanguages = ["ja-JP"]
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer)
        try? handler.perform([request])
    }
    
    func runVideo() {
        videoCapture.run { sampleBuffer in
            self.recognizeText(sampleBuffer: sampleBuffer)
            if let convertImage = self.UIImageFromSampleBuffer(sampleBuffer) {
                DispatchQueue.main.async {
                    self.buffImage = convertImage
                }
            }
        }
    }
    
}

extension OcrManager {
    func UIImageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            let context = CIContext()
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image)
            }
        }
        return nil
    }
}
