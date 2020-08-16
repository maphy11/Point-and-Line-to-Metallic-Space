//
//  TitleSerection.swift
//  caimmetal04
//
//  Created by 高部恭平 on 2020/08/16.
//  Copyright © 2020 TUT Creative Application. All rights reserved.
//

import Foundation
import simd
import QuartzCore
class TitleSerection
{
    static func TapSerection(touchPoints:[CGPoint], l1:Line, l2:Line) -> Bool
    {
        if(touchPoints.count <= 0) { return false }
        let tPos = touchPoints[0]
        let y = ((l1.p1.pos.y-l1.p2.pos.y)/(l1.p1.pos.x-l1.p2.pos.x))*(Float(tPos.x) - l1.p1.pos.x) + l1.p1.pos.y
        let x = ((l2.p1.pos.x-l2.p2.pos.x)/(l2.p1.pos.y-l2.p2.pos.y))*(Float(tPos.y) - l2.p1.pos.y) + l2.p1.pos.x
        return (Float(tPos.y) <= y)&&(Float(tPos.x) <= x)
    }
    static func LineSerection(l1:Line,l2:Line,tempLine:Line!) -> Bool
    {
        if(tempLine == nil){ return false }
        let p1:Point? = VertexGenerator.culIntersectionPoint(l1: l1, l2: tempLine)
        let p2:Point? = VertexGenerator.culIntersectionPoint(l1: l2, l2: tempLine)
        return p1 != nil && p2 != nil
    }
}
