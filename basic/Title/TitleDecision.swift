//
//  TitleDecision.swift
//  caimmetal04
//
//  Created by 高部恭平 on 2020/08/15.
//  Copyright © 2020 TUT Creative Application. All rights reserved.
//

import Foundation
import simd
import QuartzCore
class TitleDecsion
{
    static func LineDecision( dp:inout [Point], menuLines:[Line], lines:inout [Line]) -> Bool
    {
        if(dp.count < 2) { return false }
        if(menuLines.count < 2) { return false }
        let line = Line(p1: dp[0], p2: dp[1], frameCount: 0, wid: 3.0)
        
        let p1:Point? = VertexGenerator.culIntersectionPoint(l1: menuLines[0], l2: line)
        let p2:Point? = VertexGenerator.culIntersectionPoint(l1: menuLines[1], l2: line)
        lines.append(line)
        dp.removeAll()
        return p1 != nil && p2 != nil

    }
    static func TapDecision(tPoses:[CGPoint],lines:[Line]) -> Bool
    {
        if(tPoses.count <= 0) { return false }
        if(lines.count < 2) { return false }
        let tPos = tPoses[0]
        let l1 = lines[0]
        let l2 = lines[1]
        let y = ((l1.p1.pos.y-l1.p2.pos.y)/(l1.p1.pos.x-l1.p2.pos.x))*(Float(tPos.x) - l1.p1.pos.x) + l1.p1.pos.y
        let x = ((l2.p1.pos.x-l2.p2.pos.x)/(l2.p1.pos.y-l2.p2.pos.y))*(Float(tPos.y) - l2.p1.pos.y) + l2.p1.pos.x
        return (Float(tPos.y) <= y)&&(Float(tPos.x) <= x)
    }
}
