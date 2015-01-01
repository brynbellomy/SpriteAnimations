//
//  AnimationAtlasKeypath.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 29.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import BrynSwift


/**
    A keypath referring to a specific animation frame (a texture) in an `AnimationAtlas`.
*/
public struct AnimationAtlasKeypath <AnimationType : IAnimationType>
{
    /** The animation that the keypath refers to. */
    public let animation:  AnimationType

    /** The index of the animation frame that the keypath refers to. */
    public let frameIndex: Int

    /** The canonical representation of the keypath as a texture name.  It is formatted: `{animation.animationFilenameComponent}-{frameIndex}`. */
    public var textureName: String {
        let frameIndexFormatted = String(format:"%.3d", frameIndex)
        return "\(animation.animationFilenameComponent)-\(frameIndexFormatted).png"
    }

    /** The designated initializer. */
    public init(animation a:AnimationType, frameIndex fi:Int) {
        animation  = a
        frameIndex = fi
    }

    /**
        Attempts to initialize an AnimationAtlasKeypath from a texture name.  The texture
        name must be of the form `{animation.animationFilenameComponent}-{frameIndex}` for
        this initializer to succeed.
    
        :param: textureName The texture name to convert into an `AnimationAtlasKeypath`.
    */
    public init?(textureName tn:String)
    {
        let textureName = AnimationAtlasKeypath<AnimationType>.simplifyTextureName(tn)
        var parts = split(textureName) { $0 == "-" }
        if parts.count < 2 {
            return nil
        }

        let frameIndex = parts.removeLast().toInt()
        let animationStr = join("-", parts)
        let animation    = AnimationType(animationFilenameComponent:animationStr)

        if let (a, fi) = both(animation, frameIndex)? {
            self.init(animation:a, frameIndex:fi)
        }
        else {
            return nil
        }
    }

    /**
        Cleans up junk that's commonly found in `SKTextureAtlas` texture filenames (i.e., URL encodings and the path extension).
     */
    public static func simplifyTextureName(textureName:String) -> String {
        return textureName.stringByReplacingOccurrencesOfString("%20", withString: " ").stringByDeletingPathExtension
    }
}


extension AnimationAtlasKeypath : Printable {
    public var description : String { return "<AnimationAtlas.Keypath {animation = \(animation), frameIndex =\(frameIndex)}>" }
}

extension AnimationAtlasKeypath : Equatable, Comparable {}

public func < <A: IAnimationType> (lhs:AnimationAtlasKeypath<A>, rhs:AnimationAtlasKeypath<A>) -> Bool {
    return lhs.animation < rhs.animation && lhs.frameIndex < rhs.frameIndex
}

public func == <A: IAnimationType> (lhs:AnimationAtlasKeypath<A>, rhs:AnimationAtlasKeypath<A>) -> Bool {
    return lhs.animation == rhs.animation && lhs.frameIndex == rhs.frameIndex
}



