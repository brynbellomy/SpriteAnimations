//
//  IAnimationType.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public protocol IAnimationType : Equatable, Comparable, Hashable, Printable
{
    class var defaultValue : Self { get }
    var animationFilenameComponent : String { get }

    init?(animationFilenameComponent:String)
}



