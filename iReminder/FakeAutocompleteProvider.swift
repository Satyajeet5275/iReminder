//
//  FakeAutocompleteProvider.swift

import Foundation
import KeyboardKit
import UserNotifications
import Contacts
/**
 This fake autocomplete provider is used in the non-pro demo,
 to show fake suggestions while typing.
 */





protocol FakeAutocompleteProviderDelegate: AnyObject {
    func didChangeText(_ text: String)
}

class FakeAutocompleteProvider: AutocompleteProvider {
    

    weak var delegate: FakeAutocompleteProviderDelegate?

    
    init(context: AutocompleteContext) {
        self.context = context
      
    }
    
    private var context: AutocompleteContext
    private var contactStore = CNContactStore()
    
    var locale: Locale = .current
    var canIgnoreWords: Bool { false }
    var canLearnWords: Bool { false }
    var ignoredWords: [String] = []
    var learnedWords: [String] = []
 
    
    func hasIgnoredWord(_ word: String) -> Bool { false }
    func hasLearnedWord(_ word: String) -> Bool { false }
    func ignoreWord(_ word: String) {}
    func learnWord(_ word: String) {}
    func removeIgnoredWord(_ word: String) {}
    func unlearnWord(_ word: String) {}
    
    func autocompleteSuggestions(for text: String) async throws -> [Autocomplete.Suggestion] {
        guard text.count > 0 else { return [] }
        
        delegate?.didChangeText(text)
        

        let suggestions = fakeSuggestions(for: text)
        
        return suggestions.map {
            var suggestion = $0
            suggestion.isAutocorrect = $0.isAutocorrect && context.isAutocorrectEnabled
            return suggestion
        }
    }

    

}

private extension FakeAutocompleteProvider {
    func fakeSuggestions(for text: String) -> [Autocomplete.Suggestion] {
        [
            .init(text: text, isUnknown: true),
            .init(text: text, isAutocorrect: true),
            .init(text: text, subtitle: "Subtitle")
        ]
    }
}


