//
//  IAnimationType.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky


public protocol IAnimationType : Equatable, Comparable, Hashable, Printable
{
    class var defaultValue : Self { get }
    var animationFilenameComponent : String { get }

    init?(animationFilenameComponent:String)
}


public func < <T: IAnimationType> (lhs:T, rhs:T) -> Bool {
    return lhs.animationFilenameComponent < rhs.animationFilenameComponent
}


public struct AnimationOf
    <T: IAnimationType, U: IAnimationType>
    : Equatable, Hashable
{
    public var components = (T.defaultValue, U.defaultValue)
    public var hashValue: Int { return animationFilenameComponent.hashValue }
    public init() {}
    public init(one: T, two:U) { components = (one, two) }
    public init(components one: T, _ two:U) { components = (one, two) }
}

extension AnimationOf : IAnimationType
{
    public var animationFilenameComponent : String {
        return "\(components.0.animationFilenameComponent)-\(components.1.animationFilenameComponent)"
    }

    public static var defaultValue : AnimationOf<T, U> {
        return AnimationOf<T, U>()
    }

    public init?(animationFilenameComponent:String) {
        let parts = split(animationFilenameComponent) { $0 == "-" }
        if parts.count >= 2 {
            if let (one, two) = both(T(animationFilenameComponent: parts[0]), U(animationFilenameComponent: parts[1])) {
                components.0 = one
                components.1 = two
            }
            else { return nil }
        }
        else { return nil }
    }
}

extension AnimationOf : Printable {
    public var description: String { return "<AnimationOf: [\(components.0.description, components.1.description)]>" }
}

public func ==
    <T: IAnimationType, U: IAnimationType>
    (lhs: AnimationOf<T, U>, rhs:AnimationOf<T, U>) -> Bool
{

    return lhs.components.0 == rhs.components.0 && lhs.components.1 == rhs.components.1
}


