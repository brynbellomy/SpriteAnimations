//
//  AnimationControllerBuilder.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import BrynSwift
import SwiftConfig
import LlamaKit


/**
    Simplifies the building of `AnimationController` objects.
 */
public struct AnimationControllerBuilder <AnimationType: IAnimationType> : IConfigurableBuilder
{
    /** The type of `AnimationController` built by this builder. */
    public typealias BuiltType = AnimationController<AnimationType>

    /** The type of `AnimationAtlas` used by the `AnimationController` built by this builder. */
    public typealias AtlasType = BuiltType.AtlasType

    /** The name of the texture atlas (in the app's main bundle) from which to build the `AnimationController`. */
    public var textureAtlasName: String?

    /** The value of the `anchorPoint` property on the `AnimationController`'s `SKSpriteNode`. */
    public var anchorPoint: CGPoint = CGPoint(x:0.5, y:0.0)

    /** The value of the `framesPerSecond` property on the `AnimationController`. */
    public var framesPerSecond = NSTimeInterval(3)


    public init() {
    }


    public mutating func configure(config:Config)
    {
        framesPerSecond  =?? config.get("frames per second")
        textureAtlasName =?? config.get("texture atlas")
        anchorPoint      =?? config.get("anchor point")
    }


    public func build() -> Result<BuiltType, NSError>
    {
        return buildAnimationController
                    <^> buildAnimationAtlas
                            -<< (textureAtlasName ?± failure(missingValue("textureAtlasName")))
                    <*> (anchorPoint              ?± failure(missingValue("anchorPoint")))
                    <|  framesPerSecond
    }

}

private func missingValue(name:String) -> String {
    return "AnimationControllerBuilder cannot build() without a value for '\(name)'."
}

private func buildAnimationController <AnimationType: IAnimationType>
    (animationAtlas:AnimationAtlas<AnimationType>)
    (anchorPoint:CGPoint)
    (framesPerSecond:NSTimeInterval)
        -> AnimationController<AnimationType>
{
    return AnimationController(animationAtlas:animationAtlas, defaultTexture:nil, anchorPoint:anchorPoint, framesPerSecond:framesPerSecond)
}

private func buildAnimationAtlas <AnimationType: IAnimationType>
    (textureAtlasName:String)
        -> Result<AnimationAtlas<AnimationType>, NSError>
{
    var builder = AnimationAtlas<AnimationType>.Builder()
    builder.useTexturesFromAtlas(SKTextureAtlas(named:textureAtlasName))
    return builder.build()
}

