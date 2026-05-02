
# from fastapi import APIRouter, HTTPException

# from sklearn.feature_extraction.text import TfidfVectorizer
# from sklearn.naive_bayes import MultinomialNB


# from collections import deque

# from schemas.spam_user import *

# from schemas.batch_spam_request import *

# from schemas.feedback import *
# import asyncio
# from core.model import _texts  , _labels , vectorizer  ,model

# router = APIRouter()



# _feedback_buffer = deque(maxlen=1000)

# _retrain_lock = asyncio.Lock()



# @router.post("/spam/feedback")
# async def submit_feedback(request: FeedbackRequest):
#     _feedback_buffer.append({"text": request.text, "label": int(request.is_spam)})
 
 
#     return {"status": "saved", "buffer_size": len(_feedback_buffer)}

# @router.post("/spam/retrain")
# async def retrain_model():
#     async with _retrain_lock:
#         new_texts = [f["text"] for f in _feedback_buffer]
#         new_labels = [f["label"] for f in _feedback_buffer]
        
#         all_texts = _texts + new_texts
#         all_labels = _labels + new_labels
        
#         new_X = vectorizer.transform(all_texts)
#         model.fit(new_X, all_labels)
        
#         return {"status": "retrained", "samples_used": len(_feedback_buffer)}


