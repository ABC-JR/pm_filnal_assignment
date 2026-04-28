from sqlalchemy import Column, String, Text
from models.base import Base


class Song(Base):
    __tablename__ = "songs"
    
    id = Column(String, primary_key=True)
    title = Column(String, nullable=False)
    artist = Column(String, nullable=False)
    url = Column(Text)
