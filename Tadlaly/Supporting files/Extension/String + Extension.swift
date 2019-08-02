//
//  String + Extension.swift
//  Zi Elengaz
//
//  Created by mahmoudhajar on 4/19/19.
//  Copyright © 2019 CreativeShare. All rights reserved.
//

import UIKit


extension String {
    
    /// Mark: - check if string is Empty
    var isEmptyStr:Bool {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
 
    
    /*
     * check if a string is equal to another string
     * Eg: var s1: String = "string1"
     * var s2: String = "string2"
     * print(s1.isEqualToString(s2)) -> false
     */
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    
    /*
     * convert a string to JSON
     */
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    
    /*
     * get the index of a character in a string
     * Eg: var s:String = "This is a single sentence. This is another sentence."
     * let subString = s[s.indexOf(".")...] -> This will get the substring from the first index of '.' till the last index
     * print(subString) -> This is another sentence.
     */
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    
    
    /*
     * get the last index of a character in a string
     * Eg: var s:String = "This is a single sentence. This is another sentence."
     * let subString = s[s.lastIndexOf(".")...] -> This will get the substring from the first index of '.' till the last index
     * print(subString) -> .
     */
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
    
    
}
