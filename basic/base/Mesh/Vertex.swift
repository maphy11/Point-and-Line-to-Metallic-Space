//
//  Vertect.swift
//  caimmetal04
//
//  Created by 高部恭平 on 2020/08/15.
//  Copyright © 2020 TUT Creative Application. All rights reserved.
//

import Foundation
import simd
import QuartzCore

// 頂点情報の構造体
struct Vertex {
    var pos:Float2 = Float2()
    var frameCount:Int = 0
    var color:Float4 = Float4()
}

// パーティクル情報
struct Point {
    var pos:Float2 = Float2()
    var color:CAIMColor = CAIMColor()
}

struct Line{
    var p1:Point = Point()
    var p2:Point = Point()
    var frameCount:Int = 0
    var wid:Float = 0.0
}

class VertexGenerator
{
    static func genPoint(pos:CGPoint,color:CAIMColor)->Point
    {
        var p:Point = Point()
        p.pos = Float2(Float(pos.x),Float(pos.y))
        p.color = color
        return p
    }
        
        //LineをCGPointから生成する
    static func genLine(pos1:CGPoint,pos2:CGPoint,color1:CAIMColor,color2:CAIMColor,nowFrame:Int)->Line
    {
        let lineWidth:Float = 3.0
        let point1 = genPoint(pos: pos1, color: color1)
        let point2 = genPoint(pos: pos2, color: color2)
        let line:Line = Line(p1: point1, p2: point2,frameCount: nowFrame, wid: lineWidth)
        return line
    }
    static func genTriangle(points:[Point])->Triangle?
    {
        if(points.count < 3) { return nil }
        let tris:Triangle = Triangle(p1: points[0], p2: points[1], p3: points[2])
        return tris
    }
    static func culIntersectionPoint(l1: Line, l2: Line)->Point?
    {
        let ACx:Float = l2.p1.pos.x - l1.p1.pos.x
        let ACy:Float = l2.p1.pos.y - l1.p1.pos.y
        let Bunbo:Float = (l1.p2.pos.x - l1.p1.pos.x) * (l2.p2.pos.y - l2.p1.pos.y) - (l1.p2.pos.y - l1.p1.pos.y) * (l2.p2.pos.x - l2.p1.pos.x)

        if(Bunbo == 0){ return nil }
        
        let r:Float = ((l2.p2.pos.y - l2.p1.pos.y)*ACx-(l2.p2.pos.x - l2.p1.pos.x)*ACy)/Bunbo
        let s:Float = ((l1.p2.pos.y - l1.p1.pos.y)*ACx-(l1.p2.pos.x - l1.p1.pos.x)*ACy)/Bunbo
        let isIntersection = (0<=r)&&(r<=1)&&(0<=s)&&(s<=1)
        
        if(isIntersection == false) { return nil }
        
        let x:Float = l1.p1.pos.x + r * (l1.p2.pos.x - l1.p1.pos.x)
        let y:Float = l1.p1.pos.y + r * (l1.p2.pos.y - l1.p1.pos.y)
        let point:Point = Point(pos: Float2(x,y), color: CAIMColor(0.0,0.0,0.0,1.0))
        return point
    }
}


