# -*- coding: utf-8 -*-
class Word:
    def __init__(self, tag):
        tag_list = tag.split("\t")
        self.tag = tag
        print(self.tag)
        self.word = tag_list[0]
        self.label = tag_list[1]
        self.lemma = tag_list[2]
    
    def get_word(self):
        return self.word
