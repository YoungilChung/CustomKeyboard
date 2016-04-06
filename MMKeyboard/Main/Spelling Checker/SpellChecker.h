//
//  SpellChecker.h
//  MMCustomKeyboard
//
//  Created by Tom Atterton on 06/04/16.
//  Copyright © 2016 mm0030240. All rights reserved.
//

#ifndef __MMCustomKeyboard__SpellChecker__
#define __MMCustomKeyboard__SpellChecker__

#include <map>
#include <vector>

typedef std::vector<std::string> Vector;
typedef std::map<std::string, int> Dictionary;


class SpellChecker {
    
public:
    void load(const std::string &filename);
    
    Dictionary corrections(const std::string &word);
    
private:
    void editWord(const std::string &word, Vector &result);
    
    void known(Vector &results, Dictionary &candidates);
    
    Dictionary dictionary;
    
    
};

#endif /* defined(__MMCustomKeyboard__SpellChecker__) */
