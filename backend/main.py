from fastapi import FastAPI

import uvicorn

from models.user import Base, User
from models.favorite import Favorite
from models.song import Song

from routes import auth, cheker , retrain , file
from database.database import engine
from fastapi.middleware.cors import CORSMiddleware


app =FastAPI()
app.include_router(auth.router ,prefix="/auth")


app.include_router(cheker.router , prefix="/check")

app.include_router(retrain.router  , prefix="/retrain")
app.include_router(file.router  , prefix="/file")

app.add_middleware(
    CORSMiddleware ,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


Base.metadata.create_all(bind=engine)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
