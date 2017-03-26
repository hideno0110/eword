# -*- coding: utf-8 -*-
import sys
sys.path.append('/Users/ooharahidenori/app/flaskr/eword/')
import treetaggerwrapper
import os
from sqlite3 import dbapi2 as sqlite3
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash
import logging
from logging.handlers import RotatingFileHandler
from lib.word import Word
# import lib.db

# create our little application :)
app = Flask(__name__)

'''
DB connections
'''
# Load default config and override config from an environment variable
app.config.update(dict(
    DATABASE=os.path.join(app.root_path, 'eword.db'),
    DEBUG=True,
    SECRET_KEY='development key',
    USERNAME='admin',
    PASSWORD='default'
))
app.config.from_envvar('EWORD_SETTINGS', silent=True)

def connect_db():
    """Connects to the specific database."""
    rv = sqlite3.connect(app.config['DATABASE'])
    rv.row_factory = sqlite3.Row
    return rv


def init_db():
    """Initializes the database."""
    db = get_db()
    with app.open_resource('schema.sql', mode='r') as f:
        db.cursor().executescript(f.read())
    db.commit()


@app.cli.command('initdb')
def initdb_command():
    """Creates the database tables."""
    init_db()
    print('Initialized the database.')


def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db


@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


'''
Main 
'''
@app.route('/')
def show_entries():
    db = get_db()
    entry = db.execute('select id, title, text from entries order by id desc LIMIT 10')
    word = db.execute('select * from word_lists order by counter desc LIMIT 20')
    entries = entry.fetchall()
    words = word.fetchall()
    app.logger.warning(words)
    
    return render_template('index.html', entries=entries, words=words)


@app.route('/add', methods=['POST'])
def add_entry():
    if not session.get('logged_in'):
        abort(401)
    try:
        db = get_db()
        db.execute('insert into entries (title, text) values (?, ?)',
                [request.form['title'], request.form['text']])    
        
        tagdir = os.getenv('TREETAGGER_ROOT')
        tagger = treetaggerwrapper.TreeTagger(TAGLANG='en',TAGDIR=tagdir)
        tags = tagger.TagText(request.form['text'])
        tag_list = []
        for tag in tags:
            print('=========')
            print(tag)
            word = Word(tag)
            
            db.execute('INSERT OR IGNORE INTO word_lists (lemma, label, counter, word) VALUES (?, ?, ?, ?)',[word.lemma, word.label, word.word, 0])
            db.execute('UPDATE word_lists SET counter = counter + 1 WHERE lemma LIKE ?',[word.lemma])
        
        db.commit()
        flash('New entry was successfully posted')
    except:
        app.logger.warning('db error')
        flash('Entry was not success.')

    return redirect(url_for('show_entries'))


@app.route('/entry/<int:id>')
def show_entry(id):
    if not session.get('logged_in'):
        abort(401)

    print('-----------id')
    print(id)
    db = get_db()
    entry = db.execute('select id, title, text from entries where id = ?',[id])    
    # entry = db.execute('select id, title, text from entries where id = 2') 
    entry = entry.fetchone() 
    
    print('-----------entr')
    # print(entry.text)
    return render_template('entry.html', entry=entry)
    
    
'''
Login & Logout
'''
@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != app.config['USERNAME']:
            error = 'Invalid username'
        elif request.form['password'] != app.config['PASSWORD']:
            error = 'Invalid password'
        else:
            session['logged_in'] = True
            flash('You were logged in')
            return redirect(url_for('show_entries'))
    return render_template('login.html', error=error)


@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    flash('You were logged out')
    return redirect(url_for('show_entries'))


if __name__ == '__main__':
    handler = RotatingFileHandler('foo.log', maxBytes=10002, backupCount=1)
    handler.setLevel(logging.INFO)
    app.logger.addHandler(handler)
    app.run()
