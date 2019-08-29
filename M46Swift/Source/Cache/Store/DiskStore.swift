//
//  DiskStore.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public final class DiskStore<T> {
    public enum Error: Swift.Error {
        case fileEnumerator
        case malformedFileAttributes
        case fileStoreError
    }
    
    public let manager: FileManager
    private let config: DiskConfig
    public let path: String
    
    var onRemove: ((String) -> Void)?
    private let transformer: Transformer<T>
    
    public convenience init(config: DiskConfig,
                     transformer: Transformer<T>,
                     manager: FileManager = FileManager.default) throws {
        let url: URL
        if let directory = config.directory {
            url = directory
        } else {
            url = try manager.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        }
        
        let path = url.appendingPathComponent(config.name, isDirectory: true).path
        
        self.init(
            config: config,
            path: path,
            transformer: transformer,
            manager: manager
        )
        
        try createDirectory()
    }
    
    public required init(config: DiskConfig,
                  path: String,
                  transformer: Transformer<T>,
                  manager: FileManager) {
        self.config = config
        self.path = path
        self.transformer = transformer
        self.manager = manager
    }
}

typealias ResourceObject = (url: Foundation.URL, resourceValues: URLResourceValues)

extension DiskStore : StoreAware {

    public func entry(forKey key: String) throws -> Entry<T> {
        let filePath = makeFilePath(for: key)
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        let attributes = try manager.attributesOfItem(atPath: filePath)
        
        guard let date = attributes[.modificationDate] as? Date else {
            throw Error.malformedFileAttributes
        }

        let object = try transformer.fromData(data)
        
        return Entry(object: object, expiry: Expiry.date(date), filePath: filePath)
    }
    
    public func add(_ object: T, forKey key: String, expiry: Expiry?) throws {
        let expiry = expiry ?? config.expiry
        let data = try transformer.toData(object)
        let filePath = makeFilePath(for: key)
        let ok = manager.createFile(atPath: filePath, contents: data, attributes: nil)
        
        if !ok {
            throw Error.fileStoreError
        }
        
        try manager.setAttributes([.modificationDate : expiry.date], ofItemAtPath: filePath)
    }
    
    public func remove(forKey key: String) throws {
        let filePath = makeFilePath(for: key)
        try manager.removeItem(atPath: filePath)
        onRemove?(filePath)
    }
    
    public func removeAll() throws {
        try manager.removeItem(atPath: path)
        try createDirectory()
    }
    
    public func removeExpired() throws {
        let storageURL = URL(fileURLWithPath: path)
        let resourceKeys: [URLResourceKey] = [
            .contentModificationDateKey,
            .isDirectoryKey,
            .totalFileAllocatedSizeKey
        ]
        
        var resourceObjects = [ResourceObject]()
        var filesToDelete = [URL]()
        var totalSize: UInt = 0
        
        let enumerator = manager.enumerator(
            at: storageURL,
            includingPropertiesForKeys: resourceKeys,
            options: .skipsHiddenFiles,
            errorHandler: nil
        )
        
        guard let urls = enumerator?.allObjects as? [URL] else {
            throw Error.fileEnumerator
        }
        
        for url in urls {
            let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
            
            guard resourceValues.isDirectory != true else {
                continue
            }
            
            if let expiryDate = resourceValues.contentModificationDate, expiryDate.inThePast {
                filesToDelete.append(url)
            }
            
            if let fileSize = resourceValues.totalFileAllocatedSize {
                totalSize += UInt(fileSize)
                resourceObjects.append((url: url, resourceValues: resourceValues))
            }
        }
        
        for url in filesToDelete {
            try manager.removeItem(at: url)
            onRemove?(url.path)
        }
        
        try removeResourceObjects(resourceObjects, totalSize: totalSize)
    }
}

extension DiskStore {

    func createDirectory() throws -> Void {
        guard !manager.fileExists(atPath: path) else {
            return
        }
        try manager.createDirectory(
            at: URL(fileURLWithPath: path),
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    func makeFileName(for key: String) -> String {
        let fileExtension = URL(fileURLWithPath: key).pathExtension
        let fileName = key.md5()
        switch fileExtension.isEmpty {
        case true:
            return "\(fileName)"
        default:
            return "\(fileName).\(fileExtension)"
        }
        
    }
    
    func makeFilePath(for key: String) -> String {
        return "\(path)/\(makeFileName(for: key))"
    }
    
    func removeResourceObjects(_ objects: [ResourceObject], totalSize: UInt) throws {
        guard config.maxSize > 0 && totalSize > config.maxSize else {
            return
        }
        
        var totalSize = totalSize
        let targetSize = config.maxSize / 2
        
        let sortedFiles = objects.sorted {
            if let time1 = $0.resourceValues.contentModificationDate?.timeIntervalSinceReferenceDate,
                let time2 = $1.resourceValues.contentModificationDate?.timeIntervalSinceReferenceDate {
                return time1 > time2
            } else {
                return false
            }
        }
        
        for file in sortedFiles {
            try manager.removeItem(at: file.url)
            onRemove?(file.url.path)
            
            if let fileSize = file.resourceValues.totalFileAllocatedSize {
                totalSize -= UInt(fileSize)
            }
            
            if totalSize < targetSize {
                break
            }
        }
    }
    
    func transform<U>(transformer: Transformer<U>) -> DiskStore<U> {
        return DiskStore<U>(
            config: config,
            path: path,
            transformer: transformer,
            manager: manager
        )
    }
    
}




