# -*- coding: utf-8 -*-
import sys
sys.path.append('eword/')
import treetaggerwrapper
import os
from sqlite3 import dbapi2 as sqlite3
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash
import logging
from logging.handlers import RotatingFileHandler
from lib.word import Word
import requests 
# import lib.db
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = '/uploads'
ALLOWED_EXTENSIONS = set(['txt', 'pdf'])

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
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

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
    entry = db.execute('select id, title, text from entries \
            order by id desc LIMIT 10')
    word = db.execute('select * from word_lists \
            left join grammer_labels on word_lists.label_id = grammer_labels.id \
            where grammer_labels.act_flg = 1 and checked_flg = 0 \
            order by counter desc LIMIT 10')
   
    count = db.execute('select count(id) from word_lists')


    entries = entry.fetchall()
    words = word.fetchall()
    count = count.fetchone()
    count = count[0]
    print('count')
    print(count)
    app.logger.warning(words)
    
    return render_template('index.html', entries=entries, words=words, count=count)


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/add', methods=['POST'])
def add_entry():
    title = ''
    text =  ''
    
    if not session.get('logged_in'):
        abort(401)
    
    if request.form:
        title = request.form['title']
        text =  request.form['text']
    
    if 'file' in request.files:
        print('aaaaaa')
        file = request.files['file']
        if file.filename == '':
            flash('No selected file', 'error')
            return redirect(url_for('show_entries'))
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            print('===selectfile1.5======')
            print(file)
            print(filename)
            print(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            print('eword/'+ secure_filename(file.filename))
            file.save('eword/uploads'+ secure_filename(file.filename))
            # file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            f = open('eword/uploads'+ secure_filename(file.filename), 'r', encoding='utf_8')
            text = f.read()
            f.close()         
            # print('===selectfile2======')
    
    try:
        db = get_db()
        db.execute('insert into entries (title, text) values (?, ?)',
                [title, text])
        post_id = db.execute('select id from entries ORDER BY id DESC limit 1').fetchone()
        print('-----------post_id')
        print(post_id[0])
        post_id = post_id[0]
        tagdir = os.getenv('TREETAGGER_ROOT')
        tagger = treetaggerwrapper.TreeTagger(TAGLANG='en',TAGDIR=tagdir)
        tags = tagger.TagText(text)
        tag_list = []
        print('===start======')
        for tag in tags:
            print('=========')
            print(tag)
            word = Word(tag)
            
            label_id = db.execute('select id from grammer_labels where label like ?',[word.label]).fetchone()
            
            if label_id:
                label_id_int = int(label_id[0])
            else:
                label_id_int = 0
            print('=label2========')
            print(label_id_int)
            db.execute('INSERT OR IGNORE INTO word_lists (lemma, label_id, counter, word, checked_flg, post_id) VALUES (?, ?, ?, ?, ?, ?)',[word.lemma, label_id_int, word.word, 0, 0, post_id])
            print('=label3========')
            db.execute('UPDATE word_lists SET counter = counter + 1 WHERE lemma LIKE ?',[word.lemma])
        
        db.commit()
        flash('New entry was successfully posted', 'success')
    except:
        app.logger.warning('db error')
        flash('Entry was not success.', 'error')

    return redirect(url_for('show_entries'))


@app.route('/words')
def words():
    if not session.get('logged_in'):
        abort(401)
    db = get_db()
    words = db.execute('select * from word_lists left join grammer_labels on word_lists.label_id = grammer_labels.id  order by counter desc')    
    words = words.fetchall() 
    
    return render_template('words.html', words=words)


@app.route('/entry/<int:id>')
def show_entry(id):
    if not session.get('logged_in'):
        abort(401)
    db = get_db()
    entry = db.execute('select id, title, text from entries where id = ?',[id])    
    entry = entry.fetchone() 

    words = db.execute('select * from word_lists \
            left join grammer_labels on word_lists.label_id = grammer_labels.id \
            where grammer_labels.act_flg = 1 and checked_flg = 0 and post_id = ? \
            order by counter desc LIMIT 10',[id]).fetchall()
    
    return render_template('entry.html', entry=entry, words=words)
    
@app.route('/checked', methods=['POST'])
def checked():
    word_id = request.form['checked']
    print(word_id)
    print(request.form['check'])

    db = get_db()
    if request.form['check'] == '1':
        print('1---')
        entry = db.execute('update word_lists set checked_flg = ? where id = ?',[1, word_id])    
    elif  request.form['check'] == '0':
        print('2---')
        entry = db.execute('update word_lists set checked_flg = ? where id = ?',[0, word_id])    
    
    db.commit()
    return redirect(request.referrer)

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
            flash('You were logged in', 'success')
            return redirect(url_for('show_entries'))
    return render_template('login.html', error=error)


@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    flash('You were logged out', 'success')
    return redirect(url_for('show_entries'))


if __name__ == '__main__':
    handler = RotatingFileHandler('foo.log', maxBytes=10002, backupCount=1)
    handler.setLevel(logging.INFO)
    app.logger.addHandler(handler)
    app.run()
