from sqlalchemy import  create_engine 
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()
local_url =  os.getenv("local_url")




engine = create_engine(local_url)

sessionlocal = sessionmaker(bind=engine , autocommit=False , autoflush=False)


def get_db():
    db = sessionlocal()
    try:
        yield db
    finally:
        db.close()


