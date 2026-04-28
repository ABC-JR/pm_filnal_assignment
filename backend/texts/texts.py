SPAM_TEXTS = [
    "You won an iPhone! Click here right now!",
    "CONGRATULATIONS! You won $1,000,000! Claim your prize now!",
    "Free loan approved instantly! No checks required!",
    "Earn $5000 per day without investment! Limited time!",
    "You received a reward! Claim it now via this link!",
    "URGENT! Your account is suspended. Verify immediately!",
    "Buy cheap Viagra online! Best prices! Fast delivery!",
    "100% FREE! Win a car today! Register now!",
    "Send SMS now and receive your gift instantly!",
    "Hot travel deals! 90% discount! Today only!",
    "YOU ARE SELECTED! Get $500 by filling out this form!",
    "Online loan in 5 minutes! No documents required!",
    "Increase your income 10x! Proven system!",
    "Exclusive offer! Click now! Free prize! Limited time!",
    "You have been selected! Claim your reward today!",
    "Make money fast! No investment needed! Guaranteed!",
    "Cheap meds online! No prescription required!",
    "Win a free iPhone! Click here immediately!",
    "Earn money from home! No experience needed!",
    "Online casino! 100% bonus on first deposit!",
    "Your account will be deleted! Confirm now!",
    "Lottery! Win $100,000 now! Participate today!",
    "Credit approved in 1 hour! No rejection!",
    "Act now! This deal expires in 10 minutes!",
    "Click this link to unlock your reward now!",
]




HAM_TEXTS = [
    "Hi, how are you? Want to meet tomorrow?",
    "Reminder: meeting on Friday at 3 PM.",
    "Can you send me last month's report?",
    "Thanks for your help, everything worked!",
    "When is a good time to call?",
    "I’ve attached the documents for review.",
    "Do you need help with the project?",
    "Order #12345 has been received.",
    "Good afternoon, sending you the invoice.",
    "Let’s have a call on Monday.",
    "Test results are ready, everything is fine.",
    "Hi! How was the conference?",
    "Reminder: internet payment due by the 25th.",
    "Thanks for your purchase! Delivery on April 20.",
    "Hi, let me know when you're free.",
    "Please review the attached file.",
    "Thanks for your support!",
    "Meeting confirmed for Monday at 10 AM.",
    "Your package has been shipped.",
    "Can you check this document?",
    "Your request has been received.",
    "Support will contact you within an hour.",
    "I sent you the contract, please review it.",
    "Let me know if you have questions.",
    "Looking forward to your reply.",
]



SPAM_PATTERNS = [
    (r"(?i)(you\s*won|congratulations|winner)", "Winning promise", 0.9),
    (r"(?i)(free|100%\s*free|no\s*cost)", "Free offer", 0.6),

    # smarter urgency (NOT just 'urgent')
    (r"(?i)(urgent.*(click|verify)|act\s*now|limited\s*time)", "Urgency pressure", 0.7),

    (r"(?i)(earn\s*\$|make\s*money|income)", "Money promise", 0.8),
    (r"(?i)(casino|bet|gambling)", "Gambling", 0.9),
    (r"(?i)(viagra|cheap\s*meds|no\s*prescription)", "Drug promotion", 1.0),

    (r"(?i)(loan\s*approved|no\s*credit\s*check)", "Suspicious finance", 0.9),

    (r"[!]{2,}", "Too many exclamation marks", 0.4),
    (r"[A-Z]{5,}", "All caps text", 0.3),

    (r"(?i)(http[s]?://\S+|www\.\S+)", "Contains link", 0.5),

    (r"(?i)(verify\s*account|account\s*suspended|confirm\s*now)", "Phishing attempt", 1.0),

    (r"(?i)(reward|gift|prize)", "Reward promise", 0.7),

    (r"\d{5,}", "Large numbers", 0.3),

    # NEW smart patterns 👇
    (r"(?i)(click\s*here|click\s*link)", "Click bait", 0.6),
    (r"(?i)(limited\s*offer|only\s*today)", "Artificial scarcity", 0.7),
    (r"(?i)(guaranteed|risk\s*free)", "Too good to be true", 0.6),
]

