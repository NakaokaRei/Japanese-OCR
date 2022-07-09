//
//  ContentView.swift
//  Japanese-OCR
//
//  Created by NakaokaRei on 2022/06/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var ocrManager = OcrManager()
    
    var body: some View {
        ZStack {
            if let image = ocrManager.buffImage {
                Image(uiImage: image)
                    .resizable()
                    .padding(.leading, 1)
                    .scaledToFit()
            }
            
            Text(ocrManager.recognizedText)
                .fontWeight(.bold)
                .font(.largeTitle)
                .frame(width: 680, height: 191, alignment: .topLeading)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.56, green: 0.62, blue: 0.67, opacity: 0.4), Color(red: 0.91, green: 0.94, blue: 0.95, opacity: 0.4)]), startPoint: .top, endPoint: .bottom))
    }
}

