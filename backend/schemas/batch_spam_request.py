from pydantic import BaseModel
from typing import List
from schemas.spam_user import *

class BatchSpamRequest(BaseModel):
    texts: List[str]  

class BatchSpamResponse(BaseModel):
    results: List[SpamResponse]
    spam_count: int
    total: int


