//
//  AccountsData.swift
//  Payment_System
//
//  Created by Iliyan on 5/30/17.
//  Copyright © 2017 Iliyan. All rights reserved.
//

import Foundation


class AccountsData {
    var _id:String
    var _refNum:String
    var _balance:Double
    var _holder:String
    
    
    init(id:String,refNum:String,balance:Double,holder:String){
        self._id = id
        self._refNum = refNum
        self._balance = balance
        self._holder = holder
    }
    
}
