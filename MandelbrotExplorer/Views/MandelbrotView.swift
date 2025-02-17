//
//  ContentView.swift
//  Mandelbrot Explorer
//
//  Created by Aadit Bagdi on 9/25/24.
//

import SwiftUI

import SwiftUI

struct MandelbrotView: View {
  @State private var offset = CGSize.zero
  @State private var lastOffset = CGSize.zero
  @State private var scale: CGFloat = 1.0
  @State private var lastScale: CGFloat = 1.0
  @State private var baseColor = Color(.sRGB, red: 1, green: 1, blue: 1)
  @State private var showColorPicker = false
  
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
              let translationScale = 1.0 / (scale * 2)
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
              scale = lastScale * value
            }
            .onEnded { value in
              lastScale = scale
            }
        )
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              showColorPicker.toggle()
            } label: {
              HStack {
                Circle()
                  .fill(baseColor)
                  .frame(width: 20, height: 20)
                Image(systemName: "chevron.down")
                  .foregroundColor(.primary)
              }
            }
          }
        }
        .navigationTitle("MandelbrotExplorer")
        .navigationBarTitleDisplayMode(.inline)
    }
    .sheet(isPresented: $showColorPicker) {
      ColorPicker("Choose Base Color", selection: $baseColor)
        .padding()
        .presentationDetents([.height(150)])
    }
  }
}

#Preview {
  MandelbrotView()
}
