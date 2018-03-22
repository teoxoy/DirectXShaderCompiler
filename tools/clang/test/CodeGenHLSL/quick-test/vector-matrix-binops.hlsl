// RUN: %dxc -E main -T ps_6_0 %s  | FileCheck %s

// CHECK: vector-matrix-binops.hlsl:24:14: warning: implicit truncation of vector type
// CHECK: vector-matrix-binops.hlsl:31:16: warning: implicit truncation of vector type
// CHECK: vector-matrix-binops.hlsl:36:24: error: type mismatch
// CHECK: vector-matrix-binops.hlsl:37:27: error: type mismatch
// CHECK: vector-matrix-binops.hlsl:39:14: warning: implicit truncation of vector type
// CHECK: vector-matrix-binops.hlsl:52:27: error: type mismatch
// CHECK: vector-matrix-binops.hlsl:53:27: error: type mismatch

void main() {

    float4 v4 = float4(0.1f, 0.2f, 0.3f, 0.4f);
    float3 v3 = float3(0.1f, 0.2f, 0.3f);
    float2 v2 = float2(0.5f, 0.6f);
    float4x4 m44 = float4x4(v4, v4, v4, v4);
    float2x2 m22 = float2x2(0.1f, 0.2f, 0.3f, 0.4f);
    float1x4 m14 = float1x4(v4);
    float3x2 m32 = float3x2(0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f);

    // vector truncation
    {
      float2 res1 = v2 * v4; // expected-warning {{implicit truncation of vector type}} 
      float2 res2 = v4 - v3; // expected-warning {{implicit truncation of vector type}} 
    }

    // matrix truncation
    {
      float1x4 res1 = m44 / m14; // expected-warning {{implicit truncation of vector type}} 
      float1x4 res2 = m14 - m44; // expected-warning {{implicit truncation of vector type}} 
      float2x2 res3 = m44 + m32; // expected-warning {{implicit truncation of vector type}} 
    }

    // matrix and vector binary operation - mismatched dimensions
    {
      float4 res1 = v4 * m44; // expected-error {{type mismatch}}
      float4x4 res2 = m44 + v4; // expected-error {{type mismatch}}
      float3 res3 = v3 * m14; // expected-warning {{implicit truncation of vector type}} 
      float2 res4 = m14 / v2; // expected-warning {{implicit truncation of vector type}} 
    }

    // matrix and vector binary operation - matching dimensions - no warnings expected
    {
      float4 res1 = v4 / m22;
      float2x2 res2 = m22 - v4;
      float4 res3 = v4 + m14;
    }
    
    // matrix mismatched dimensions
    {
      float2x3 m23 = float2x3(1, 2, 3, 4, 5, 6);
      float3x2 res1 = m23 - m32; // expected-error {{type mismatch}}
      float1x4 res2 = m14 / m23; // expected-error {{type mismatch}}
    }
}