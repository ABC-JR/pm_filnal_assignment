from sqlalchemy import Column, String, Text, ForeignKey
from models.base import Base
from sqlalchemy.orm import relationship


class Favorite(Base):
    __tablename__ = "favorites"
    
    id = Column(Text, primary_key=True)
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    song_id = Column(String, ForeignKey("songs.id"), nullable=False)
    
    user = relationship("User", back_populates="favorites")
    song = relationship("Song")
