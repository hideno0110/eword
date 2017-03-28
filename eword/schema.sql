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
  label_id integer,
  counter integer,
  post_id integer,
  checked_flg integer,
  user_id integer
);

create table grammer_labels (
  id integer primary key autoincrement,
  label text,
  name text,
  ex text,
  name_jp text,
  act_flg integer
);


insert into grammer_labels (id, label, name, ex, act_flg) values (2, "CC", "coordinating conjunction", "and, but, or, &",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (2, "CD", "cardinal number", "2, three",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (3, "DT", "determiner", "the",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (4, "EX", "existential there", "there is",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (5, "FW", "foreign word", "d'œuvre",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (6, "IN", "preposition/subord. conj.", "in,of,like,after,whether",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (7, "IN/that", "complementizer", "that",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (8, "JJ", "adjective", "green",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (9, "JJR", "adjective, comparative", "greener",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (10,"JJS", "adjective, superlative", "greenest",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (11,"LS", "list marker", "(1),",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (12,"MD", "modal", "could, will",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (13,"NN", "noun, singular or mass", "table",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (14,"NNS", "noun plural", "tables",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (15,"NP", "proper noun, singular", "John",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (16,"NPS", "proper noun, plural", "Vikings",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (17,"PDT", "predeterminer", "both the boys",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (18,"POS", "possessive ending", "friend's",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (19,"PP", "personal pronoun", "I, he, it",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (20,"PP$", "possessive pronoun", "my, his",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (21,"RB", "adverb", "however, usually, here, not",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (22,"RBR", "adverb, comparative", "better",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (23,"RBS", "adverb, superlative", "best",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (24,"RP", "particle", "give up",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (25,"SENT", "end punctuation", "?, !, .",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (26,"SYM", "symbol", "@, +, *, ^, |, =",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (27,"TO", "to", "to go, to him",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (28,"UH", "interjection", "uhhuhhuhh",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (29,"VB", "verb be, base form", "be",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (30,"VBD", "verb be, past", "was|were",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (31,"VBG", "verb be, gerund/participle", "being",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (32,"VBN", "verb be, past participle", "been",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (33,"VBZ", "verb be, pres, 3rd p. sing", "is",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (34,"VBP", "verb be, pres non-3rd p.", "am|are",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (35,"VD", "verb do, base form", "do",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (36,"VDD", "verb do, past", "did",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (37,"VDG", "verb do gerund/participle", "doing",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (38,"VDN", "verb do, past participle", "done",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (39,"VDZ", "verb do, pres, 3rd per.sing", "does",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (40,"VDP", "verb do, pres, non-3rd per.", "do",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (41,"VH", "verb have, base form", "have",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (42,"VHD", "verb have, past", "had",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (43,"VHG", "verb have, gerund/participle", "having",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (44,"VHN", "verb have, past participle", "had",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (45,"VHZ", "verb have, pres 3rd per.sing", "has",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (46,"VHP", "verb have, pres non-3rd per.", "have",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (47,"VV", "verb, base form", "take",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (48,"VVD", "verb, past tense", "took",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (49,"VVG", "verb, gerund/participle", "taking",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (50,"VVN", "verb, past participle", "taken",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (51,"VVP", "verb, present, non-3rd p.", "take",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (52,"VVZ", "verb, present 3d p. sing.", "takes",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (53,"WDT", "wh-determiner", "which",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (54,"WP", "wh-pronoun", "who, what",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (55,"WP$", "possessive wh-pronoun", "whose",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (56,"WRB", "wh-abverb", "where, when",1);
insert into grammer_labels (id, label, name, ex, act_flg) values (57,":", "general joiner", ";, -, --",0);
insert into grammer_labels (id, label, name, ex, act_flg) values (58,"$", "currency symbol", "$, £",0);
