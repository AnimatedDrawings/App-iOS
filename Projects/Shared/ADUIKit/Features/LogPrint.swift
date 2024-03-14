//
//  LogPrint.swift
//  ADUIKit
//
//  Created by chminii on 3/14/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public func logPrint(
  startLog: Any? = nil,
  endLog: Any? = nil,
  file: String = #file,
  line: Int = #line,
  `func`: String = #function
) {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "HH:mm:ss:SSS"
  
  if let startLog = startLog {
    print(startLog)
  }
  print("myLogPrint : \(dateFormatter.string(from: Date())) file: \(file) line: \(line) func: \(`func`)")
  if let endLog = endLog {
    print(endLog)
  }
}
