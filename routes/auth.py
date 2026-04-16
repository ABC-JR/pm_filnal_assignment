
from fastapi import APIRouter, Depends, HTTPException, Header

from middleware.auth_middleware import auth_middleware
from models.user import User  

from models.favorite import Favorite

import uuid
import bcrypt

from schemas.user_create import UserCreate
from database.database import get_db
from sqlalchemy.orm import Session

from schemas.user_login import UserLogin
import jwt
from sqlalchemy.orm import joinedload

router = APIRouter()






@router.post("/signup" , status_code=201)
def signup(user: UserCreate , db :Session = Depends(get_db)):

    existing = db.query(User).filter(User.email == user.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already exists")

    

    hashed_password = bcrypt.hashpw(
        user.password.encode() , bcrypt.gensalt()
    )
    user_query  = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_password)
    
    db.add(user_query)
    db.commit()
    db.refresh(user_query)

    return {"message": "User created successfully", "user": user}






@router.post("/login")
def login(user: UserLogin , db :Session = Depends(get_db)):


    existing = db.query(User).filter(User.email == user.email).first()
    
    if not existing:
        raise HTTPException(status_code=404, detail="User not found")
    is_match = bcrypt.checkpw(user.password.encode() , existing.password)

    if not is_match:
        raise HTTPException(status_code=400, detail="Invalid login or password")
    
    token = jwt.encode({'id':existing.id} , 'password_key')
    
    return {
        'token': token , 'user': existing
    }




@router.get("/")
def current_user_data(db:Session = Depends(get_db) , user =  Depends(auth_middleware)):
   

    finuser = db.query(Favorite).filter(Favorite.id == user.id).options(
        joinedload(Favorite.song) ,
        joinedload(Favorite.user)

    ).first()



    return finuser     

