//
//  Fractals.metal
//  MetalKit-Fractal
//
//  Created by Zhenya Peteliev on 25.11.2019.
//  Copyright © 2019 Yevhenii Peteliev. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void computeFractal(texture2d<float, access::write> output [[texture(0)]],
                           constant float &timer [[buffer(1)]],
                           constant float &color [[buffer(2)]],
                           uint2 gid [[thread_position_in_grid]])
{
    int width = output.get_width();
    int height = output.get_height();

    float2 uv = float2(gid) / float2(width, height);

    float2 cc = 1.1 * float2( 0.5 * cos(0.1 * timer) - 0.25 * cos(0.2 * timer), 0.5 * sin(0.1 * timer) - 0.25 * sin(0.2 * timer));
    float4 dmin = float4(1000.0);
    float2 z = (-1.0 + 2.0 * uv) * float2(1.7, 1.0);

    for (int i = 0; i < 64; i++) {
        z = cc + float2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y);
        dmin = min(dmin, float4(abs(0.0 + z.y + 0.5 * sin(z.x)), abs(1.0 + z.x + 0.5 * sin(z.y)), dot(z, z), length(fract(z) - 0.5)));
    }

    float3 color_vector = float3(color);
    color_vector = mix(color_vector, float3(0.40, 0.60, 0.40), min(1.0, pow(dmin.x * 0.25, 0.20)));
    color_vector = mix(color_vector, float3(0.40, 0.60, 0.40), min(1.0, pow(dmin.y * 0.50, 0.50)));
    color_vector = mix(color_vector, float3(1.00, 1.00, 1.00), 1.0 - min(1.0, pow(dmin.z * 1.00, 0.15)));
    color_vector = 1.25 * color_vector * color_vector;
    color_vector *= 0.5 + 0.5 * pow(16.0 * uv.x * (1.0 - uv.x) * uv.y * (1.0 - uv.y), 0.15);

    output.write(float4(color_vector, 1), gid);
}

