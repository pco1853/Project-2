//
//  SavingMethods.swift
//  DataDownloader
//
//  Created by Jason  on 4/13/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import Foundation
import UIKit

//var pathToArchivedFile:String?

var pathToArchivedFile = FilePathInDocumentsDirectory("allConcertEvents.archive")
func DocumentsDirectory() -> String
{
    return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as String
}

func FilePathInDocumentsDirectory(fileName: String) -> String
{
    println(DocumentsDirectory())
    return DocumentsDirectory().stringByAppendingPathComponent(fileName)
}

