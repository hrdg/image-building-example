# copied from https://github.com/datacamp/courses-msft-transact-sql
pip3 install git+git://github.com/datacamp/sqlwhat-ext --no-deps

# Follow ideas from https://github.com/datacamp/docker-msft-sql-base/blob/master/requirements.sh

wget https://s3.amazonaws.com/assets.datacamp.com/production/course_5315/datasets/create-co2-database.sql

./start_server.sh

# Simple task: return available tables
isql Default sa $SA_PASSWORD -v < create-co2-database.sql
