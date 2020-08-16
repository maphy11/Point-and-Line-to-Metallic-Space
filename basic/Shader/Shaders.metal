//
// Shaders.metal

#include <metal_stdlib>

using namespace metal;

// 入力頂点情報
struct VertexIn
{
    float2 pos;
    int    frame;
    float4 rgba;
};

// 出力頂点情報
struct VertexOut
{
    float4 pos [[position]];
    //float2 uv;
    float4 rgba;
};

struct TextureIn
{
    float2 pos;
    int frame;
    float4 rgba;
    float2 uv;
};

struct TextureOut
{
    float4 position [[ position ]];
    float2 texCoords;
};

// 必要なシェーダを作成する...
// 頂点シェーダー(2Dピクセル座標系)
vertex VertexOut vertLine(device VertexIn *vin [[ buffer(0) ]],
                        constant float4x4 &proj_matrix [[ buffer(1) ]],
                        uint idx [[ vertex_id ]])
{
    VertexOut vout;
    // float2に、z=0,w=1を追加 → float4を作成し、行列を使って座標変換
    vout.pos = proj_matrix * float4(vin[idx].pos, 0, 1);
    //vout.uv  = vin[idx].uv;
    vout.rgba = vin[idx].rgba;
    
    return vout;
}

vertex VertexOut vertTriangle(device VertexIn *vin [[ buffer(0) ]],
                        constant float4x4 &proj_matrix [[ buffer(1) ]],
                        uint idx [[ vertex_id ]])
{
    VertexOut vout;
    // float2に、z=0,w=1を追加 → float4を作成し、行列を使って座標変換
    vout.pos = proj_matrix * float4(vin[idx].pos, 0, 1);
    //vout.uv  = vin[idx].uv;
    vout.rgba = vin[idx].rgba;
    
    float r = (vout.pos.y + 1) / 2;
    vout.rgba[0] = vout.rgba[0] * (1-r*r);
    vout.rgba[1] = vout.rgba[1] * (1-r*r);
    vout.rgba[2] = vout.rgba[2] * (1-r*r);
    
    return vout;
}

vertex TextureOut texture2D(device TextureIn *vin [[ buffer(0) ]],
                            constant float4x4 &proj_matrix [[ buffer(1) ]],
                            uint idx [[ vertex_id ]])
{
    TextureOut out;
    out.position = proj_matrix * float4(vin[idx].pos, 0, 1);
    out.texCoords = vin[idx].uv;
    return out;
}

vertex VertexOut vertRotate(device VertexIn *vin [[ buffer(0) ]],
                            constant float4x4 &proj_matrix [[ buffer(1) ]],
                            constant float4x4 &rotate_matrix [[ buffer(2) ]],
                            constant float4x4 &transform_matrix [[ buffer(3) ]],
                            uint idx [[ vertex_id ]])
{
    VertexOut vout;
    float rotate_angle = 2 * vin[idx].frame;
    float4x4 rotate_mat = rotate_matrix;
    rotate_mat[0][0] = cos((rotate_angle/180) * M_PI_F);
    rotate_mat[0][2] = -sin((rotate_angle/180) * M_PI_F);
    rotate_mat[2][0] = sin((rotate_angle/180) * M_PI_F);
    rotate_mat[2][2] = cos((rotate_angle/180) * M_PI_F);
    float4x4 mat =  proj_matrix * rotate_mat * transform_matrix;
    vout.pos = mat * float4(vin[idx].pos, 0, 1);
    vout.rgba = vin[idx].rgba;
    return vout;
}

fragment float4 fragStandard(VertexOut vout [[ stage_in ]])
{
    return vout.rgba;
}

fragment float4 fragLine(VertexOut vout [[ stage_in ]])
{
    float4 rgba = vout.rgba;
    return rgba;
}

fragment float4 fragTriangle(VertexOut vout [[ stage_in ]])
{
    
    float4 rgba = vout.rgba;
    return rgba;
}

fragment float4 fragTexture(TextureOut       in      [[ stage_in ]],
                               texture2d<float> texture [[ texture(0) ]])
{
    constexpr sampler colorSampler;
    float4 color = texture.sample(colorSampler, in.texCoords);
    return color;
}

