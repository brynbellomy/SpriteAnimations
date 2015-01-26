//
//  TestHelpers.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2015 Jan 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteAnimations


func pathForFilename(filename:String, inBundle bundleClass:AnyClass) -> String? {
    return NSBundle(forClass:bundleClass).pathForResource(filename.stringByDeletingPathExtension, ofType:filename.pathExtension)
}

func imageForKeypath(keypath:AnimationAtlas<Animation>.Keypath, inBundle bundleClass:AnyClass) -> NSImage?
{
    if let filepath = pathForFilename("\(keypath.textureName).png", inBundle:bundleClass)? {
        if let filedata = NSData(contentsOfFile:filepath)? {
            return NSImage(data: filedata)
        }
    }
    return nil
}



func buildTextureAtlas(#bundleClass:AnyClass) -> SKTextureAtlas?
{
    var dict = [NSObject: AnyObject]()
    for animation in [Animation.WalkingUp, .WalkingDown, .WalkingLeft, .WalkingRight]
    {
        for i in 0 ..< 4
        {
            let keypath = AnimationAtlas.Keypath(animation:animation, frameIndex:i + 1)
            if let image = imageForKeypath(keypath, inBundle:bundleClass)? {
               dict[keypath.textureName] = image
            }
            else { return nil }
        }
    }

    return SKTextureAtlas(dictionary: dict)
}
