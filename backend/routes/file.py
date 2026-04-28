


import shutil 

import whisper

from fastapi import APIRouter, HTTPException , UploadFile, File

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB


from collections import deque

from schemas.spam_user import *

from schemas.batch_spam_request import *

from schemas.feedback import *
import asyncio
from core.model import _texts  , _labels , vectorizer  ,model



router = APIRouter()
model = whisper.load_model("base")

@router.post('/toText')
async def transcribe(file: UploadFile = File(...)):
    with open("temp.mp3", "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    result = model.transcribe("temp.mp3")
    return {"text": result["text"]}

    



