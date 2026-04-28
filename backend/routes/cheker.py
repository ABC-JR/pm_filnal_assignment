from fastapi import APIRouter, HTTPException

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB

import re
from collections import deque

from schemas.spam_user import *

from schemas.batch_spam_request import *
from schemas.feedback import *
from core.model import *



router = APIRouter()


@router.post("/spam", response_model=SpamResponse)
async def check_spam(request: SpamRequest):
    text = request.text.strip()

    if not text:
        raise HTTPException(status_code=400, detail="Text cannot be empty")

    try:
       
        X_input = vectorizer.transform([text])
        proba = model.predict_proba(X_input)[0]
        ml_spam_prob = float(proba[1])


        reasons, rule_weight = analyze_rules(text)

     
        combined_score = min(
            ml_spam_prob * ML_WEIGHT + rule_weight * RULE_WEIGHT,
            1.0
        )

        confidence = int(round(combined_score * 100))
        score = int(round(combined_score * 10))
      
        normalized_rule = min(rule_weight / 2.5, 1.0)
        combined = ml_spam_prob * 0.7 + normalized_rule * 0.3
        is_spam = combined >= 0.5

        # Verdict
        if is_spam:
            verdict = "SPAM"
            summary = (
                "This message is clearly spam."
                if confidence >= 80
                else "This message is likely spam."
            )
        else:
            verdict = "NOT SPAM"
            summary = (
                "This looks like a normal message."
                if confidence <= 20
                else "This is probably not spam."
            )

        if not reasons:
            reasons = (
                ["No spam indicators detected"]
                if not is_spam
                else ["Detected as spam by ML model"]
            )

        return SpamResponse(
            verdict=verdict,
            confidence=confidence,
            score=score,
            reasons=reasons,
            summary=summary
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    

@router.post("/spam/batch", response_model=BatchSpamResponse)
async def check_spam_batch(request: BatchSpamRequest):
    if len(request.texts) > 100:
        raise HTTPException(400, "Max 100 texts per batch")
    results = [await check_spam(SpamRequest(text=t)) for t in request.texts]
    spam_count = sum(1 for r in results if r.verdict == "SPAM")
    return BatchSpamResponse(results=results, spam_count=spam_count, total=len(results))