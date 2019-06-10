//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/5/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
