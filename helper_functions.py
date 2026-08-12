"""
===========================================================
HELPER FUNCTIONS
Customer Support Reporting Analyst Portfolio Project
===========================================================
Reusable helper functions used throughout the project.
===========================================================
"""

import random
from faker import Faker
from datetime import datetime, timedelta

from business_rules import (
    FIRST_RESPONSE,
    RESOLUTION_TIME,
    ESCALATION_RATE,
    STATUS_WEIGHTS
)

fake = Faker("en_IN")

# ==========================================================
# CUSTOMER ID
# ==========================================================

def generate_customer_id(number):
    """
    Returns:
    CUST000001
    """

    return f"CUST{number:06d}"


# ==========================================================
# TICKET ID
# ==========================================================

def generate_ticket_id(number):
    """
    Returns:
    TKT100001
    """

    return f"TKT{100000 + number}"


# ==========================================================
# PHONE NUMBER
# ==========================================================

def generate_phone():

    first_digit = random.choice(["6", "7", "8", "9"])

    remaining = "".join(
        str(random.randint(0, 9))
        for _ in range(9)
    )

    return first_digit + remaining


# ==========================================================
# CUSTOMER EMAIL
# ==========================================================

def generate_email(name):

    clean = (
        name.lower()
        .replace(".", "")
        .replace("'", "")
        .replace(" ", "")
    )

    domains = [
        "gmail.com",
        "outlook.com",
        "yahoo.com",
        "hotmail.com",
        "icloud.com"
    ]

    return f"{clean}{random.randint(1,999)}@{random.choice(domains)}"


# ==========================================================
# RANDOM TICKET DATE
# ==========================================================

def generate_ticket_date():

    end_date = datetime.now()

    start_date = end_date - timedelta(days=365)

    return fake.date_time_between(
        start_date=start_date,
        end_date=end_date
    )


# ==========================================================
# FIRST RESPONSE TIME
# ==========================================================

def first_response_minutes(priority):

    minimum, maximum = FIRST_RESPONSE[priority]

    return random.randint(minimum, maximum)


# ==========================================================
# RESOLUTION HOURS
# ==========================================================

def resolution_hours(priority):

    minimum, maximum = RESOLUTION_TIME[priority]

    return random.randint(minimum, maximum)


# ==========================================================
# RESPONSE DATETIME
# ==========================================================

def response_datetime(ticket_datetime, response_minutes):

    return ticket_datetime + timedelta(
        minutes=response_minutes
    )


# ==========================================================
# RESOLUTION DATETIME
# ==========================================================

def resolution_datetime(ticket_datetime, hours):

    return ticket_datetime + timedelta(
        hours=hours
    )


# ==========================================================
# SLA CHECK
# ==========================================================

def sla_met(actual_hours, sla_hours):

    return "Yes" if actual_hours <= sla_hours else "No"


# ==========================================================
# ESCALATION
# ==========================================================

def escalated(priority):

    probability = ESCALATION_RATE[priority]

    return random.choices(
        ["Yes", "No"],
        weights=[probability, 100 - probability],
        k=1
    )[0]


# ==========================================================
# STATUS
# ==========================================================

def ticket_status():

    statuses = list(STATUS_WEIGHTS.keys())

    weights = list(STATUS_WEIGHTS.values())

    return random.choices(
        statuses,
        weights=weights,
        k=1
    )[0]


# ==========================================================
# RANDOM CUSTOMER
# ==========================================================

def customer_name():

    return fake.name()



# ==========================================================
# CUSTOMER SATISFACTION (CSAT)
# ==========================================================

def customer_csat(status, resolution_hours):

    """
    Generates a realistic CSAT score.

    Open/Pending tickets:
        No rating

    Faster resolution:
        Higher chance of good ratings.
    """

    if status in ["Open", "Pending"]:
        return None

    if resolution_hours <= 8:
        return random.randint(4, 5)

    elif resolution_hours <= 24:
        return random.randint(3, 5)

    elif resolution_hours <= 48:
        return random.randint(3, 4)

    else:
        return random.randint(1, 4)


# ==========================================================
# REOPENED TICKET
# ==========================================================

def reopened(status):

    """
    Closed/Resolved tickets have a small chance
    of being reopened.
    """

    if status in ["Resolved", "Closed"]:

        return random.choices(
            ["Yes", "No"],
            weights=[7, 93],
            k=1
        )[0]

    return "No"


# ==========================================================
# PRIORITY FROM ISSUE
# ==========================================================

def get_priority(issue_master, issue):

    return issue_master[issue]["priority"]


# ==========================================================
# SLA HOURS FROM ISSUE
# ==========================================================

def get_sla(issue_master, issue):

    return issue_master[issue]["sla"]


# ==========================================================
# CUSTOMER SEGMENT
# ==========================================================

def customer_segment():

    return random.choices(

        ["Retail", "Premium", "Corporate"],

        weights=[75, 20, 5],

        k=1

    )[0]


# ==========================================================
# BUSINESS HOURS FLAG
# ==========================================================

def business_hours(ticket_datetime):

    hour = ticket_datetime.hour

    if 9 <= hour < 18:
        return "Yes"

    return "No"


# ==========================================================
# WEEKEND FLAG
# ==========================================================

def weekend(ticket_datetime):

    if ticket_datetime.weekday() >= 5:
        return "Yes"

    return "No"


# ==========================================================
# MONTH NAME
# ==========================================================

def month_name(ticket_datetime):

    return ticket_datetime.strftime("%B")


# ==========================================================
# DAY NAME
# ==========================================================

def day_name(ticket_datetime):

    return ticket_datetime.strftime("%A")


# ==========================================================
# QUARTER
# ==========================================================

def quarter(ticket_datetime):

    month = ticket_datetime.month

    if month <= 3:
        return "Q1"

    elif month <= 6:
        return "Q2"

    elif month <= 9:
        return "Q3"

    return "Q4"


# ==========================================================
# AGING (OPEN TICKETS)
# ==========================================================

def aging(ticket_datetime, status):

    """
    Returns ticket age in days.

    Only applicable for Open/Pending tickets.
    """

    if status in ["Resolved", "Closed"]:
        return 0

    return (datetime.now() - ticket_datetime).days


# ==========================================================
# FIRST CONTACT RESOLUTION
# ==========================================================

def first_contact_resolution(reopened_ticket):

    if reopened_ticket == "Yes":
        return "No"

    return "Yes"


# ==========================================================
# DATE FORMATTING
# ==========================================================

def format_datetime(date_value):

    if date_value is None:
        return None

    return date_value.strftime("%Y-%m-%d %H:%M:%S")