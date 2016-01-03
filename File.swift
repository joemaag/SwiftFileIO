//
//  File.swift
//  FileIO
//
//  Created by Joseph Maag on 12/31/15.
//  Copyright © 2015 Joseph Maag. All rights reserved.
//
//
//  File I/O operations use the POSIX API.
//  Read and write are declared in unistd.h. Open is defined in fcntl.h.
//

import Foundation

class File {
    
    enum FileAccessType { //for the file to opened
        case ReadOnly
        case WriteOnly
        case ReadAndWrite
        case ReadOnlyAndAppend, WriteOnlyAndAppend, ReadAndWriteAndAppend
    }
    
    struct CreatedFileAccessTypes : OptionSetType {
        let rawValue: mode_t
        static let OwnerRead = CreatedFileAccessTypes(rawValue: S_IRUSR)
        static let OwnerWrite = CreatedFileAccessTypes(rawValue: S_IWUSR)
        static let OwnerExecute = CreatedFileAccessTypes(rawValue: S_IXUSR)
        static let GroupRead = CreatedFileAccessTypes(rawValue: S_IRGRP)
        static let GroupWrite = CreatedFileAccessTypes(rawValue: S_IWGRP)
        static let GroupExecute = CreatedFileAccessTypes(rawValue: S_IXGRP)
        static let OtherUsersRead = CreatedFileAccessTypes(rawValue: S_IROTH)
        static let OtherUsersWrite = CreatedFileAccessTypes(rawValue: S_IWOTH)
        static let OtherUsersExecute = CreatedFileAccessTypes(rawValue: S_IXOTH)
    }
    
    let name: String
    let identifier: CInt
    let accessType: FileAccessType
    var createdFileAccessType: mode_t = 0o666 //default value is w/r for owner, group, and users
    
    init?(fileName: String, accessType: FileAccessType) {
        name = fileName
        self.accessType = accessType
        
        let flag: CInt
        
        switch accessType {
        case .ReadOnly:
            flag = O_RDONLY
        case .WriteOnly:
            flag = O_WRONLY
        case .ReadAndWrite:
            flag = O_RDWR
            
        case .ReadOnlyAndAppend:
            flag = O_RDONLY | O_APPEND
        case .WriteOnlyAndAppend:
            flag = O_WRONLY | O_APPEND
        case .ReadAndWriteAndAppend:
            flag = O_RDWR | O_APPEND
        }
        
        identifier = open("/tmp/scratch.txt", flag, S_IRUSR)
        if identifier == -1 { return nil }
        
    }
    
    init?(fileName: String, accessType: FileAccessType, createdFileAccessType: mode_t) {
        name = fileName
        self.accessType = accessType
        self.createdFileAccessType = createdFileAccessType
        
        let flag: CInt
        
        switch accessType {
        case .ReadOnly:
            flag = O_RDONLY
        case .WriteOnly:
            flag = O_WRONLY
        case .ReadAndWrite:
            flag = O_RDWR
            
        case .ReadOnlyAndAppend:
            flag = O_RDONLY | O_APPEND
        case .WriteOnlyAndAppend:
            flag = O_WRONLY | O_APPEND
        case .ReadAndWriteAndAppend:
            flag = O_RDWR | O_APPEND
        }
        
        identifier = open(fileName, flag, createdFileAccessType)
        if identifier == -1 { return nil }
        
    }

}