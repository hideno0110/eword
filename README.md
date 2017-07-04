# eword
      1. edit the configuration in the eword.py file or
         export an EWORD_SETTINGS environment variable
         pointing to a configuration file.

      2. install the app from the root of the project directory

         pip install --editable .

      3. Instruct flask to use the right application

         export FLASK_APP=eword

      4. initialize the database with this command:

         flask initdb

      5. now you can run flaskr:

         flask run

         the application will greet you on
         http://localhost:5000/

    ~ Is it tested?

      You betcha.  Run `python setup.py test` to see
      the tests pass.
