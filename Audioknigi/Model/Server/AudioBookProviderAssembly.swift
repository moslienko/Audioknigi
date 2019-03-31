//
//  AudioBookProviderAssembly.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 31/03/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import Foundation
import Typhoon

class AudioBookProviderAssembly: TyphoonAssembly {
    @objc public dynamic func config() -> AnyObject {
        return TyphoonDefinition.withConfigName("ProviderConfiguration.plist")
    }
    
    @objc public dynamic func serverProviderService() -> AnyObject {
        return TyphoonDefinition.withClass(AudioBookProvider.self) {
            (definition) in
            definition?.injectProperty(#selector(getter: AudioBookProvider.name), with:TyphoonConfig("name"))
            definition?.injectProperty(#selector(getter: AudioBookProvider.url), with:TyphoonConfig("url"))
            } as AnyObject
    }
    
    @objc public dynamic func booksCollectionViewController() -> AnyObject {
        return TyphoonDefinition.withClass(AudioBooksCollectionViewController.self) {
            (definition) in
            definition?.injectProperty(#selector(getter: AudioBooksCollectionViewController.serverProviderService), with:self.serverProviderService())
            
            definition?.scope = TyphoonScope.singleton
            } as AnyObject
    }
}
