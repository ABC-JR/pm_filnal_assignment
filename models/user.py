
from sqlalchemy import Column , String , Text , LargeBinary

from models.base import Base
from sqlalchemy.orm import relationship

class User(Base):
    __tablename__ = "users"
    id = Column(Text , primary_key=True)
    name = Column(Text, nullable=False)
    email = Column(String, nullable=False, unique=True)
    password = Column(LargeBinary, nullable=False)


    favorites = relationship("Favorite" , back_populates='user')

    