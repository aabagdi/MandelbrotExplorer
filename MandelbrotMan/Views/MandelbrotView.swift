//
//  ContentView.swift
//  Mandelbrot Explorer
//
//  Created by Aadit Bagdi on 9/25/24.
//

import SwiftUI

struct MandelbrotView: View {
  @State private var offset = CGSize.zero
  @State private var lastOffset = CGSize.zero
  @State private var scale: CGFloat = 1.0
  @State private var lastScale: CGFloat = 1.0
  @State private var baseColor = Color(.sRGB, red: 1, green: 1, blue: 1)
  
  var body: some View {
    NavigationStack {
      Color.white
        .ignoresSafeArea()
        .mandelbrotShader(
          offset: offset,
          scale: scale,
          color: baseColor
        )
        .gesture(
          DragGesture(minimumDistance: 0)
            .onChanged { value in
              let multiplier: CGFloat = 2
              let translationScale = multiplier / (scale * 2)
              offset = CGSize(
                width: lastOffset.width - value.translation.width * translationScale,
                height: lastOffset.height - value.translation.height * translationScale
              )
            }
            .onEnded { value in
              lastOffset = offset
            }
        )
        .gesture(
          MagnificationGesture()
            .onChanged { value in
              let newScale = lastScale * value
              switch newScale {
              case ..<1:
                scale = 1
              case 100000...:
                scale = 100000
              default:
                scale = newScale
              }
            }
            .onEnded { value in
              lastScale = scale
              print(scale)
            }
        )
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            ColorPicker("", selection: $baseColor, supportsOpacity: false)
          }
        }
    }
  }
}

#Preview {
  MandelbrotView()
}
