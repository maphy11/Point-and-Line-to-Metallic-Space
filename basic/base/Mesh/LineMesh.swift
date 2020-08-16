//
//  Line.swift
//  caimmetal04
//
//  Created by 高部恭平 on 2020/08/15.
//  Copyright © 2020 TUT Creative Application. All rights reserved.
//

import Foundation
import Metal
class LineMesh
{
    var lines = CAIMMetalQuadrangles<Vertex>()
    func genLineMesh(linesData:[Line])
    {
        lines.resize(count: linesData.count)
        for i:Int in 0 ..< lines.count
        {
            let line:Line = linesData[i]
               
            let vertexPoint:[Point] = culLineWidth(line: line)
               
            lines[i].p1 = Vertex(pos: vertexPoint[0].pos, frameCount: line.frameCount, color: vertexPoint[0].color.float4)
            lines[i].p2 = Vertex(pos: vertexPoint[1].pos, frameCount: line.frameCount, color: vertexPoint[1].color.float4)
            lines[i].p3 = Vertex(pos: vertexPoint[2].pos, frameCount: line.frameCount, color: vertexPoint[2].color.float4)
            lines[i].p4 = Vertex(pos: vertexPoint[3].pos, frameCount: line.frameCount, color: vertexPoint[3].color.float4)
        }
    }
    //Lineの端点情報からLineの幅を計算する
    private func culLineWidth(line:Line)->[Point]
    {
        //傾きを求め，幅を足す
        let point1:Point = line.p1
        let point2:Point = line.p2
        let deltaX:Float = point2.pos.x - point1.pos.x
        let deltaY:Float = point2.pos.y - point1.pos.y
        
        if(deltaX==0.0)
        {
            var points:[Point] = [Point](repeating: Point(), count: 4)
            points[0] = Point(pos: Float2(point1.pos.x - line.wid,point1.pos.y), color: point1.color)
            points[1] = Point(pos: Float2(point1.pos.x + line.wid,point1.pos.y), color: point1.color)
            points[2] = Point(pos: Float2(point2.pos.x - line.wid,point2.pos.y), color: point2.color)
            points[3] = Point(pos: Float2(point2.pos.x + line.wid,point2.pos.y), color: point2.color)
            
            return points
        }
        
        if(deltaY==0.0)
        {
            var points:[Point] = [Point](repeating: Point(), count: 4)
            points[0] = Point(pos: Float2(point1.pos.x ,point1.pos.y - line.wid), color: point1.color)
            points[1] = Point(pos: Float2(point2.pos.x,point2.pos.y - line.wid), color: point2.color)
            points[2] = Point(pos: Float2(point1.pos.x,point1.pos.y + line.wid), color: point1.color)
            points[3] = Point(pos: Float2(point2.pos.x,point2.pos.y + line.wid), color: point2.color)
            
            return points
        }
        
        let gradient = -deltaX/deltaY
        
        let dx:Float = line.wid * sqrt(1/(1+gradient*gradient))
        let dy:Float = gradient * dx
        
        var points:[Point] = [Point](repeating: Point(), count: 4)
        points[0] = Point(pos: Float2(point1.pos.x + dx ,point1.pos.y + dy), color: point1.color)
        points[1] = Point(pos: Float2(point2.pos.x + dx,point2.pos.y + dy), color: point2.color)
        points[2] = Point(pos: Float2(point1.pos.x - dx,point1.pos.y - dy), color: point1.color)
        points[3] = Point(pos: Float2(point2.pos.x - dx,point2.pos.y - dy), color: point2.color)
        
        return points
    }
}
