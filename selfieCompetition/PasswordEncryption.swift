//
//  PasswordEncryption.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/26/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import Foundation

class PasswordEncrypter {
  
  let salt          = String("selfieWars")?.data(using: .utf8)!
  let keyByteCount  = 16
  let rounds        = 1000000
  
  func pbkdf2SHA256(password: String) -> Data? {
    return pbkdf2(hash:CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password:password, salt:salt!, keyByteCount:keyByteCount, rounds:rounds)
  }
  
  private func pbkdf2(hash :CCPBKDFAlgorithm, password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
    let passwordData = password.data(using:String.Encoding.utf8)!
    var derivedKeyData = Data(repeating:0, count:keyByteCount)
    
    let derivationStatus = derivedKeyData.withUnsafeMutableBytes {derivedKeyBytes in
      salt.withUnsafeBytes { saltBytes in
        
        CCKeyDerivationPBKDF(
          CCPBKDFAlgorithm(kCCPBKDF2),
          password, passwordData.count,
          saltBytes, salt.count,
          hash,
          UInt32(rounds),
          derivedKeyBytes, derivedKeyData.count)
      }
    }
    if (derivationStatus != 0) {
      print("Error: \(derivationStatus)")
      return nil;
    }
    
    return derivedKeyData
  }
}
