//
//  Shaders.metal
//  ATasteofMetal
//
//  Created by Cody Morley on 1/17/22.
//

#include <metal_stdlib>
#include "ShaderDefinitions.h"
using namespace metal;

struct VertexShaderOut {
    float4 color;
    float4 pos [[position]];
};

vertex VertexShaderOut vertexShader(const device Vertex *vertexArray[[buffer(0)]],
                                    unsigned int vid [[vertex_id]]) {
    Vertex in = vertexArray[vid];
    VertexShaderOut out;
    out.color = in.color;
    out.pos = float4(in.pos.x, in.pos.y, 0, 1);
    return out;
}

fragment float4 fragmentShader(VertexShaderOut interpolated [[stage_in]]) {
    return interpolated.color;
}
