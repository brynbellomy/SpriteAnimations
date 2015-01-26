//
//  AnimationComponentBuilder.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import Funky
import SwiftConfig
import LlamaKit
import SwiftLogger


/**
    Simplifies the building of `AnimationComponent` objects.
 */
public struct AnimationComponentBuilder <A: IAnimationType>: IConfigurableBuilder
{
    /** The type of `AnimationComponent` built by this builder. */
    public typealias BuiltType = AnimationComponent<A>

    /** The type of `AnimationAtlas` used by the `AnimationComponent` built by this builder. */
    public typealias AtlasType = BuiltType.AtlasType

    /** The name of the texture atlas (in the app's main bundle) from which to build the `AnimationComponent`. */
    public var textureAtlasName: String?

    /** The file extension (like "png") of the image files in the texture atlas. */
    public var fileExtension: String = "png"

    /** The value of the `anchorPoint` property on the `AnimationComponent`'s `SKSpriteNode`. */
    public var anchorPoint = CGPoint(x:0.5, y:0.0)

    /** The value of the `framesPerSecond` property on the `AnimationComponent`. */
    public var framesPerSecond = NSTimeInterval(3)


    public init() {
    }


    public mutating func configure(config:Config)
    {
        textureAtlasName =?? config.get(keypath:["animation", "texture atlas"])
        fileExtension    =?? config.get("file extension")
        anchorPoint      =?? config.get("anchor point")
        framesPerSecond  =?? config.get("frames per second")
    }


    public func build() -> Result<BuiltType>
    {
        let buildAtlasWithFileExtension: String -> (String -> Result<AnimationAtlas<A>>) = curry(buildAnimationAtlas)

        return buildAnimationComponent(anchorPoint, framesPerSecond)
                        <^> buildAtlasWithFileExtension(fileExtension)
                                -<< (textureAtlasName ?± missingValueFailure("textureAtlasName"))
    }

}


func missingValueFailure <T> (name:String) -> Result<T> {
    return failure("AnimationComponentBuilder cannot build() without a value for '\(name)'.")
}


private func buildAnimationComponent <A: IAnimationType>
    (anchorPoint:CGPoint, framesPerSecond:NSTimeInterval) -> AnimationAtlas<A> -> AnimationComponent<A>
{
    return { animationAtlas in
        return AnimationComponent(animationAtlas:animationAtlas, defaultTexture:nil, anchorPoint:anchorPoint, framesPerSecond:framesPerSecond)
    }
}

private func buildAnimationAtlas <A: IAnimationType>
    (fileExtension:String, textureAtlasName:String) -> Result<AnimationAtlas<A>>
{
    var builder = AnimationAtlas<A>.Builder()
    let atlas   = SKTextureAtlas(named:textureAtlasName)

    assert(atlas != nil, "atlas '\(textureAtlasName)' was nil")
    assert(atlas!.textureNames.count > 0, "atlas '\(textureAtlasName)' count was 0")

    builder.useTexturesFromAtlas(atlas, fileExtension:fileExtension)

    return builder.build()
}



