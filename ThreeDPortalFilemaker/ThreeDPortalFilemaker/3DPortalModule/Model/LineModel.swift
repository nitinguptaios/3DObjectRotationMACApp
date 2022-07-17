//
//  LineModel.swift
//  ThreeDPortalFilemaker
//
//  Created by iPHTech36 on 01/07/22.
//

import SceneKit

struct Line {
    var pointA: Point?
    var pointB: Point?
}

struct Point {
    var teethNumber: CGFloat
    var point: simd_float3?
}
