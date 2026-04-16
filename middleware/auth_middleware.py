
from fastapi import HTTPException
import jwt

from models.user import User

from fastapi import Header, Depends
from sqlalchemy.orm import Session
from database.database import get_db

def auth_middleware(
    db: Session = Depends(get_db),   # ✅ берем из dependency
    x_auth_token: str = Header(...)  # ✅ берем из headers
):
    try:
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="Token missing")
        
        payload = jwt.decode(x_auth_token, 'password_key', algorithms=['HS256'])
        user_id = payload.get('id')

        response = db.query(User).filter(User.id == user_id).first()

        if response is None:
            raise HTTPException(status_code=404, detail="User not found")

        return response
        
    except jwt.PyJWKError:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")