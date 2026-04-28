from pydantic import BaseModel

class SpamRequest(BaseModel):
    text: str


class SpamResponse(BaseModel):
    verdict: str
    confidence: int
    score: int
    reasons: list[str]
    summary: str
