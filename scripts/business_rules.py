"""
===========================================================
BUSINESS RULES
Customer Support Reporting Analyst Portfolio Project
===========================================================
This file stores all master data and business rules used
to generate realistic customer support tickets.
===========================================================
"""

import random

# ==========================================================
# PRODUCTS
# ==========================================================

PRODUCTS = [
    "Savings Account",
    "Current Account",
    "Credit Card",
    "Debit Card",
    "Personal Loan",
    "Home Loan",
    "Car Loan",
    "Fixed Deposit",
    "Internet Banking",
    "Mobile Banking",
    "UPI",
    "Insurance",
    "Rewards Program",
    "Digital Wallet"
]

# ==========================================================
# SUPPORT CHANNELS
# ==========================================================

CHANNELS = [
    "Phone",
    "Email",
    "Chat",
    "Web Portal"
]

# ==========================================================
# CUSTOMER CITIES
# ==========================================================

CITIES = [
    "Mumbai",
    "Delhi",
    "Bengaluru",
    "Hyderabad",
    "Chennai",
    "Pune",
    "Ahmedabad",
    "Surat",
    "Vadodara",
    "Rajkot",
    "Bhuj",
    "Jaipur",
    "Lucknow",
    "Nagpur",
    "Indore",
    "Bhopal",
    "Patna",
    "Kolkata",
    "Noida",
    "Gurugram",
    "Kochi",
    "Coimbatore",
    "Visakhapatnam",
    "Nashik",
    "Aurangabad",
    "Kanpur",
    "Varanasi",
    "Mysuru",
    "Bhubaneswar",
    "Chandigarh"
]

# ==========================================================
# CITY TO STATE
# ==========================================================

STATE_MAP = {

    "Mumbai":"Maharashtra",
    "Delhi":"Delhi",
    "Bengaluru":"Karnataka",
    "Hyderabad":"Telangana",
    "Chennai":"Tamil Nadu",
    "Pune":"Maharashtra",
    "Ahmedabad":"Gujarat",
    "Surat":"Gujarat",
    "Vadodara":"Gujarat",
    "Rajkot":"Gujarat",
    "Bhuj":"Gujarat",
    "Jaipur":"Rajasthan",
    "Lucknow":"Uttar Pradesh",
    "Nagpur":"Maharashtra",
    "Indore":"Madhya Pradesh",
    "Bhopal":"Madhya Pradesh",
    "Patna":"Bihar",
    "Kolkata":"West Bengal",
    "Noida":"Uttar Pradesh",
    "Gurugram":"Haryana",
    "Kochi":"Kerala",
    "Coimbatore":"Tamil Nadu",
    "Visakhapatnam":"Andhra Pradesh",
    "Nashik":"Maharashtra",
    "Aurangabad":"Maharashtra",
    "Kanpur":"Uttar Pradesh",
    "Varanasi":"Uttar Pradesh",
    "Mysuru":"Karnataka",
    "Bhubaneswar":"Odisha",
    "Chandigarh":"Chandigarh"

}

# ==========================================================
# ISSUE CATEGORIES
# (Weight controls how often the issue appears)
# ==========================================================

ISSUE_MASTER = {

    "Login Issue":{
        "priority":"Low",
        "sla":48,
        "weight":10
    },

    "Password Reset":{
        "priority":"Low",
        "sla":24,
        "weight":9
    },

    "UPI Failure":{
        "priority":"High",
        "sla":8,
        "weight":8
    },

    "Payment Failed":{
        "priority":"High",
        "sla":8,
        "weight":8
    },

    "Refund Pending":{
        "priority":"Medium",
        "sla":24,
        "weight":7
    },

    "Card Blocked":{
        "priority":"High",
        "sla":4,
        "weight":6
    },

    "Transaction Dispute":{
        "priority":"High",
        "sla":8,
        "weight":5
    },

    "Fraud Complaint":{
        "priority":"High",
        "sla":4,
        "weight":3
    },

    "Loan Query":{
        "priority":"Medium",
        "sla":24,
        "weight":7
    },

    "Insurance Claim":{
        "priority":"Medium",
        "sla":24,
        "weight":5
    },

    "KYC Update":{
        "priority":"Medium",
        "sla":24,
        "weight":7
    },

    "Account Statement":{
        "priority":"Low",
        "sla":48,
        "weight":6
    },

    "Credit Card Limit":{
        "priority":"Medium",
        "sla":24,
        "weight":5
    },

    "Charges Inquiry":{
        "priority":"Medium",
        "sla":24,
        "weight":5
    },

    "Account Closure":{
        "priority":"Medium",
        "sla":48,
        "weight":2
    },

    "EMI Query":{
        "priority":"Medium",
        "sla":24,
        "weight":5
    },

    "Mobile App Error":{
        "priority":"Low",
        "sla":48,
        "weight":6
    },

    "Internet Banking Error":{
        "priority":"Low",
        "sla":48,
        "weight":6
    },

    "Account Freeze":{
        "priority":"High",
        "sla":6,
        "weight":3
    },

    "General Inquiry":{
        "priority":"Low",
        "sla":72,
        "weight":8
    }

}

# ==========================================================
# STATUS
# ==========================================================

STATUS_WEIGHTS = {

    "Resolved":70,
    "Closed":18,
    "Pending":6,
    "Open":6

}

# ==========================================================
# PRIORITY RESPONSE TIME
# (Minutes)
# ==========================================================

FIRST_RESPONSE = {

    "High":(5,30),

    "Medium":(20,120),

    "Low":(30,360)

}

# ==========================================================
# RESOLUTION HOURS
# ==========================================================

RESOLUTION_TIME = {

    "High":(2,18),

    "Medium":(8,60),

    "Low":(24,120)

}

# ==========================================================
# ESCALATION %
# ==========================================================

ESCALATION_RATE = {

    "High":30,

    "Medium":12,

    "Low":4

}

# ==========================================================
# REOPEN %
# ==========================================================

REOPEN_RATE = 7

# ==========================================================
# HELPER FUNCTIONS
# ==========================================================

def random_issue():
    """
    Returns a weighted random issue category.
    """

    issues = list(ISSUE_MASTER.keys())

    weights = [
        ISSUE_MASTER[i]["weight"]
        for i in issues
    ]

    return random.choices(
        issues,
        weights=weights,
        k=1
    )[0]
