//
//  TriangleMesh.swift
//  caimmetal04
//
//  Created by 高部恭平 on 2020/08/15.
//  Copyright © 2020 TUT Creative Application. All rights reserved.
//

import Foundation
import Metal
class TriangleMesh
{
    var triangles = CAIMMetalTriangles<Vertex>()
    func genTriangleMesh(triangleDatas:[Triangle])
    {
        triangles.resize(count: triangleDatas.count)
        for i in 0 ..< triangles.count
        {
            let tris: Triangle = triangleDatas[i]
            
            triangles[i].p1 = Vertex(pos: tris.p1.pos, frameCount: 0, color: CAIMColor(1.0,1.0,1.0,0.5).float4)
            triangles[i].p2 = Vertex(pos: tris.p2.pos, frameCount: 0, color: CAIMColor(1.0,1.0,1.0,0.5).float4)
            triangles[i].p3 = Vertex(pos: tris.p3.pos, frameCount: 0, color: CAIMColor(1.0,1.0,1.0,0.5).float4)
        }
    }
}
