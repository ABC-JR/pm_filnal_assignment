from pydantic import BaseModel

class FeedbackRequest(BaseModel):
    text: str
    is_spam: bool