//
//  Mandelbrot.metal
//  Mandelbrot Explorer
//
//  Created by Aadit Bagdi on 2/16/25.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 mandelbrot(float2 position, half4 color, float2 size, float2 offset, float scale, float3 baseColor) {
  float aspectRatio = size.x / size.y;

  float2 normalizedPos;
  if (aspectRatio > 1.0) {
    normalizedPos = float2(
                           (position.x / size.x - 0.5) * 2.0 * aspectRatio,
                           (position.y / size.y - 0.5) * 2.0
                           );
  } else {
    normalizedPos = float2(
                           (position.x / size.x - 0.5) * 2.0,
                           (position.y / size.y - 0.5) * 2.0 / aspectRatio
                           );
  }
  
  float2 c = float2(
                    normalizedPos.x * 1.5 / scale - 0.5 + offset.x / 200.0,
                    normalizedPos.y * 1.5 / scale + offset.y / 200.0
                    );
  
  float2 z = float2(0.0, 0.0);
  
  int maxIter = int(min(100 + log2(scale) * 25.0, 1000.0));
  int iter = 0;
  
  float final_x = 0.0;
  float final_y = 0.0;
  
  for (; iter < maxIter; iter++) {
    float x = z.x * z.x - z.y * z.y + c.x;
    float y = 2.0 * z.x * z.y + c.y;
    
    if (x * x + y * y > 4.0) {
      final_x = x;
      final_y = y;
      break;
    }
    
    if (isinf(x) || isinf(y)) {
      break;
    }
    
    z = float2(x, y);
  }
  
  if (iter == maxIter) {
    return half4(0.0, 0.0, 0.0, 1.0);
  } else {
    float smoothColor = float(iter) + 1.0 - log2(log2(final_x * final_x + final_y * final_y));
    smoothColor = smoothColor / float(maxIter);

    float intensity = (sin(smoothColor * 6.28) * 0.5 + 0.5);
    
    return half4(
                 half(baseColor.x * intensity),
                 half(baseColor.y * intensity),
                 half(baseColor.z * intensity),
                 1.0
                 );
  }
}
