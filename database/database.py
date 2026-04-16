from sqlalchemy import  create_engine 
from sqlalchemy.orm import sessionmaker
local_url = "postgresql://postgres:1234@localhost:5432/fluttermusicapp"


engine = create_engine(local_url)

sessionlocal = sessionmaker(bind=engine , autocommit=False , autoflush=False)


def get_db():
    db = sessionlocal()
    try:
        yield db
    finally:
        db.close()

