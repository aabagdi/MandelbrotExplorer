//
//  View+MandelbrotShader.swift
//  Mandelbrot Explorer
//
//  Created by Aadit Bagdi on 2/16/25.
//

import SwiftUI

extension View {
  func mandelbrotShader(offset: CGSize, scale: CGFloat, color: Color) -> some View {
    modifier(MandelbrotShader(offset: offset, scale: scale, color: color))
  }
}

struct MandelbrotShader: ViewModifier {
  let offset: CGSize
  let scale: CGFloat
  let color: Color
  
  func body(content: Content) -> some View {
    content.visualEffect { content, proxy in
      let components = color.resolve(in: EnvironmentValues())
      return content
        .colorEffect(ShaderLibrary.mandelbrot(
          .float2(proxy.size),
          .float2(Float(offset.width), Float(offset.height)),
          .float(Float(scale)),
          .float3(Float(components.red), Float(components.green), Float(components.blue))
        ))
    }
  }
}
