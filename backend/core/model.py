
from texts.texts import SPAM_PATTERNS, HAM_TEXTS, SPAM_TEXTS
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB

import re


from schemas.spam_user import *

from schemas.batch_spam_request import *
from schemas.feedback import *
from core.model import *






def analyze_rules(text: str):
    triggers = []
    total_weight = 0.0

    for pattern, reason, weight in SPAM_PATTERNS:
        if re.search(pattern, text, re.IGNORECASE):
            triggers.append(reason)
            total_weight += weight

    return triggers, total_weight





ML_WEIGHT = 0.6
RULE_WEIGHT = 0.4
SPAM_THRESHOLD = 0.45

_texts = SPAM_TEXTS + HAM_TEXTS
_labels = [1] * len(SPAM_TEXTS) + [0] * len(HAM_TEXTS)

vectorizer = TfidfVectorizer(
    analyzer="char_wb",
    ngram_range=(2, 4),
    max_features=5000
)

X = vectorizer.fit_transform(_texts)

model = MultinomialNB(alpha=0.1)
model.fit(X, _labels)




