drop table if exists entries;
create table entries (
  id integer primary key autoincrement,
  title text not null,
  text text not null
);


create table word_lists (
  id integer primary key autoincrement,
  lemma text not null UNIQUE,
  word text not null,
  label text,
  counter integer,
  post_id integer,
  user_id integer
);

create table grammer_labels (
  id integer primary key autoincrement,
  label text,
  name text,
  ex text,
  name_jp text
);


insert into grammer_labels (id, label, name, ex) values (1, "CC", "coordinating conjunction", "and, but, or, &");
insert into grammer_labels (id, label, name, ex) values (2, "CD", "cardinal number", "2, three");
insert into grammer_labels (id, label, name, ex) values (3, "DT", "determiner", "the");
insert into grammer_labels (id, label, name, ex) values (4, "EX", "existential there", "there is");
insert into grammer_labels (id, label, name, ex) values (5, "FW", "foreign word", "d'œuvre");
insert into grammer_labels (id, label, name, ex) values (6, "IN", "preposition/subord. conj.", "in,of,like,after,whether");
insert into grammer_labels (id, label, name, ex) values (7, "IN/that", "complementizer", "that");
insert into grammer_labels (id, label, name, ex) values (8, "JJ", "adjective", "green");
insert into grammer_labels (id, label, name, ex) values (9, "JJR", "adjective, comparative", "greener");
insert into grammer_labels (id, label, name, ex) values (10," JJS", "adjective, superlative", "greenest");
insert into grammer_labels (id, label, name, ex) values (11," LS", "list marker", "(1),");
insert into grammer_labels (id, label, name, ex) values (12," MD", "modal", "could, will");
insert into grammer_labels (id, label, name, ex) values (13," NN", "noun, singular or mass", "table");
insert into grammer_labels (id, label, name, ex) values (14," NNS", "noun plural", "tables");
insert into grammer_labels (id, label, name, ex) values (15," NP", "proper noun, singular", "John");
insert into grammer_labels (id, label, name, ex) values (16," NPS", "proper noun, plural", "Vikings");
insert into grammer_labels (id, label, name, ex) values (17," PDT", "predeterminer", "both the boys");
insert into grammer_labels (id, label, name, ex) values (18," POS", "possessive ending", "friend's");
insert into grammer_labels (id, label, name, ex) values (19," PP", "personal pronoun", "I, he, it");
insert into grammer_labels (id, label, name, ex) values (20," PP$", "possessive pronoun", "my, his");
insert into grammer_labels (id, label, name, ex) values (21," RB", "adverb", "however, usually, here, not");
insert into grammer_labels (id, label, name, ex) values (22," RBR", "adverb, comparative", "better");
insert into grammer_labels (id, label, name, ex) values (23," RBS", "adverb, superlative", "best");
insert into grammer_labels (id, label, name, ex) values (24," RP", "particle", "give up");
insert into grammer_labels (id, label, name, ex) values (25," SENT", "end punctuation", "?, !, .");
insert into grammer_labels (id, label, name, ex) values (26," SYM", "symbol", "@, +, *, ^, |, =");
insert into grammer_labels (id, label, name, ex) values (27," TO", "to", "to go, to him");
insert into grammer_labels (id, label, name, ex) values (28," UH", "interjection", "uhhuhhuhh");
insert into grammer_labels (id, label, name, ex) values (29," VB", "verb be, base form", "be");
insert into grammer_labels (id, label, name, ex) values (30," VBD", "verb be, past", "was|were");
insert into grammer_labels (id, label, name, ex) values (31," VBG", "verb be, gerund/participle", "being");
insert into grammer_labels (id, label, name, ex) values (32," VBN", "verb be, past participle", "been");
insert into grammer_labels (id, label, name, ex) values (33," VBZ", "verb be, pres, 3rd p. sing", "is");
insert into grammer_labels (id, label, name, ex) values (34," VBP", "verb be, pres non-3rd p.", "am|are");
insert into grammer_labels (id, label, name, ex) values (35," VD", "verb do, base form", "do");
insert into grammer_labels (id, label, name, ex) values (36," VDD", "verb do, past", "did");
insert into grammer_labels (id, label, name, ex) values (37," VDG", "verb do gerund/participle", "doing");
insert into grammer_labels (id, label, name, ex) values (38," VDN", "verb do, past participle", "done");
insert into grammer_labels (id, label, name, ex) values (39," VDZ", "verb do, pres, 3rd per.sing", "does");
insert into grammer_labels (id, label, name, ex) values (40," VDP", "verb do, pres, non-3rd per.", "do");
insert into grammer_labels (id, label, name, ex) values (41," VH", "verb have, base form", "have");
insert into grammer_labels (id, label, name, ex) values (42," VHD", "verb have, past", "had");
insert into grammer_labels (id, label, name, ex) values (43," VHG", "verb have, gerund/participle", "having");
insert into grammer_labels (id, label, name, ex) values (44," VHN", "verb have, past participle", "had");
insert into grammer_labels (id, label, name, ex) values (45," VHZ", "verb have, pres 3rd per.sing", "has");
insert into grammer_labels (id, label, name, ex) values (46," VHP", "verb have, pres non-3rd per.", "have");
insert into grammer_labels (id, label, name, ex) values (47," VV", "verb, base form", "take");
insert into grammer_labels (id, label, name, ex) values (48," VVD", "verb, past tense", "took");
insert into grammer_labels (id, label, name, ex) values (49," VVG", "verb, gerund/participle", "taking");
insert into grammer_labels (id, label, name, ex) values (50," VVN", "verb, past participle", "taken");
insert into grammer_labels (id, label, name, ex) values (51," VVP", "verb, present, non-3rd p.", "take");
insert into grammer_labels (id, label, name, ex) values (52," VVZ", "verb, present 3d p. sing.", "takes");
insert into grammer_labels (id, label, name, ex) values (53," WDT", "wh-determiner", "which");
insert into grammer_labels (id, label, name, ex) values (54," WP", "wh-pronoun", "who, what");
insert into grammer_labels (id, label, name, ex) values (55," WP$", "possessive wh-pronoun", "whose");
insert into grammer_labels (id, label, name, ex) values (56," WRB", "wh-abverb", "where, when");
insert into grammer_labels (id, label, name, ex) values (57," :", "general joiner", ";, -, --");
insert into grammer_labels (id, label, name, ex) values (58," $", "currency symbol", "$, £");
