//
//  UniversalGadgets.swift
//  storesearch
//
//  Created by 한석희 on 12/31/20.
//

import UIKit

func checkOnMain(){
    print( "On main thread? " + ( Thread.current.isMainThread ? "YES" : "NO" ) )
}
