API project for ML for smart trip planning

Excel: https://docs.google.com/spreadsheets/d/1FW78cMva9Qj_zOwn6HdRN1Wx_IwE0hzpwIAa8EYvF_I/edit?usp=sharing

python version: 3.10
# Setup
- Virtual Environment: `python3 -m venv venv`
- Activate the Virtual Environment: `source venv/bin/activate`
- Deactivate the Virtual Environment: `deactivate`
- Install From venv: `pip3 install -r requirements.txt`

# Migration database
- alembic revision -m "create_table_post" (create migration file)
- alembic upgrade head (run migration)

# Run Project
- python3 main.py