"""
============================================================
GENERATE CUSTOMER SUPPORT TICKETS
Reporting Analyst Portfolio Project

Author : Unsi Rathod
Version : 1.0
============================================================
"""

# ==========================================================
# IMPORT LIBRARIES
# ==========================================================

import pandas as pd
from pathlib import Path

# ==========================================================
# IMPORT BUSINESS RULES
# ==========================================================

from business_rules import (
    PRODUCTS,
    CHANNELS,
    CITIES,
    STATE_MAP,
    ISSUE_MASTER,
    random_issue
)

# ==========================================================
# IMPORT HELPER FUNCTIONS
# ==========================================================

from helper_functions import (
    generate_customer_id,
    generate_ticket_id,
    generate_phone,
    generate_email,
    generate_ticket_date,
    first_response_minutes,
    resolution_hours,
    response_datetime,
    resolution_datetime,
    sla_met,
    escalated,
    ticket_status,
    customer_name,
    customer_csat,
    reopened,
    get_priority,
    get_sla
)

# ==========================================================
# PROJECT PATHS
# ==========================================================

PROJECT_FOLDER = Path(r"C:\Users\unsir\Desktop\Customer Support")

DATA_FOLDER = PROJECT_FOLDER / "Data"

AGENT_FILE = DATA_FOLDER / "agent_master_indian.csv"

OUTPUT_FILE = DATA_FOLDER / "customer_support_tickets.csv"

# ==========================================================
# LOAD AGENTS
# ==========================================================

agents = pd.read_csv(AGENT_FILE)

print("=" * 60)
print("AGENT MASTER LOADED")
print("=" * 60)
print(f"Total Agents : {len(agents)}")

# ==========================================================
# DATASET SETTINGS
# ==========================================================

NUMBER_OF_TICKETS = 10000

tickets = []

print("\nStarting ticket generation...\n")

# ==========================================================
# GENERATE ONE CUSTOMER SUPPORT TICKET
# ==========================================================

def generate_ticket(ticket_number):

    # ------------------------------------------------------
    # CUSTOMER DETAILS
    # ------------------------------------------------------

    customer = customer_name()

    customer_id = generate_customer_id(ticket_number)

    email = generate_email(customer)

    phone = generate_phone()

    city = pd.Series(CITIES).sample(1).iloc[0]

    state = STATE_MAP[city]

    # ------------------------------------------------------
    # PRODUCT & ISSUE
    # ------------------------------------------------------

    product = pd.Series(PRODUCTS).sample(1).iloc[0]

    issue = random_issue()

    priority = get_priority(
        ISSUE_MASTER,
        issue
    )

    sla_hours = get_sla(
        ISSUE_MASTER,
        issue
    )

    # ------------------------------------------------------
    # TICKET DETAILS
    # ------------------------------------------------------

    ticket_id = generate_ticket_id(ticket_number)

    ticket_date = generate_ticket_date()

    channel = pd.Series(CHANNELS).sample(1).iloc[0]

    status = ticket_status()

    # ------------------------------------------------------
    # ASSIGN AGENT
    # ------------------------------------------------------

    agent = agents.sample(1).iloc[0]

    assigned_agent = agent["agent_name"]

    agent_id = f"AG{int(agent['agent_id']):03d}"

    team = agent["team"]

    manager = agent["manager"]

    # ------------------------------------------------------
    # RESPONSE
    # ------------------------------------------------------

    response_minutes = first_response_minutes(priority)

    response_date = response_datetime(
        ticket_date,
        response_minutes
    )

    # ------------------------------------------------------
    # RESOLUTION
    # ------------------------------------------------------

    if status in ["Resolved", "Closed"]:

        resolution_time = resolution_hours(priority)

        resolution_date = resolution_datetime(
            ticket_date,
            resolution_time
        )

        sla_result = sla_met(
            resolution_time,
            sla_hours
        )

        csat = customer_csat(
            status,
            resolution_time
        )

    else:

        resolution_time = None

        resolution_date = None

        sla_result = None

        csat = None

    # ------------------------------------------------------
    # ESCALATION
    # ------------------------------------------------------

    escalation = escalated(priority)

    # ------------------------------------------------------
    # REOPEN
    # ------------------------------------------------------

    reopen = reopened(status)

    # ------------------------------------------------------
    # RETURN RECORD
    # ------------------------------------------------------

    return {

        "Ticket_ID": ticket_id,

        "Ticket_Date": ticket_date,

        "Customer_ID": customer_id,

        "Customer_Name": customer,

        "Customer_Email": email,

        "Phone_Number": phone,

        "City": city,

        "State": state,

        "Product": product,

        "Issue_Category": issue,

        "Priority": priority,

        "Channel": channel,

        "Status": status,

        "Assigned_Agent": assigned_agent,

        "Agent_ID": agent_id,

        "Team": team,

        "Manager": manager,

        "First_Response_Minutes": response_minutes,

        "Resolution_Hours": resolution_time,

        "SLA_Hours": sla_hours,

        "SLA_Met": sla_result,

        "Escalated": escalation,

        "Customer_CSAT": csat,

        "Resolution_Date": resolution_date,

        "Reopened": reopen

    }

# ==========================================================
# GENERATE ALL TICKETS
# ==========================================================

print("=" * 60)
print("Generating Customer Support Tickets...")
print("=" * 60)

for ticket_number in range(1, NUMBER_OF_TICKETS + 1):

    ticket = generate_ticket(ticket_number)

    tickets.append(ticket)

    if ticket_number % 1000 == 0:

        print(f"{ticket_number} tickets generated...")

# ==========================================================
# CREATE DATAFRAME
# ==========================================================

df = pd.DataFrame(tickets)

# ==========================================================
# SORT DATA
# ==========================================================

df = df.sort_values(
    by="Ticket_Date"
).reset_index(drop=True)

print("\nDataset created successfully.")

print(f"Total Records : {len(df)}")
print(f"Total Columns : {len(df.columns)}")

# ==========================================================
# FORMAT DATE COLUMNS
# ==========================================================

df["Ticket_Date"] = pd.to_datetime(df["Ticket_Date"])

df["Resolution_Date"] = pd.to_datetime(
    df["Resolution_Date"]
)

# ==========================================================
# SAVE DATASET
# ==========================================================

df.to_csv(
    OUTPUT_FILE,
    index=False
)

# ==========================================================
# SUMMARY
# ==========================================================

print("\n" + "=" * 60)
print("CUSTOMER SUPPORT DATASET GENERATED SUCCESSFULLY")
print("=" * 60)

print(f"Total Tickets      : {len(df):,}")
print(f"Total Columns      : {len(df.columns)}")
print(f"Total Agents       : {agents['agent_id'].nunique()}")
print(f"Output File        : {OUTPUT_FILE}")

print("=" * 60)

# ==========================================================
# DATA QUALITY CHECK
# ==========================================================

print("\nMissing Values")

print(df.isnull().sum())

print("\n")

print("=" * 60)

print("Ticket Status Distribution")

print("=" * 60)

print(df["Status"].value_counts())

print("\n")

print("=" * 60)

print("Priority Distribution")

print("=" * 60)

print(df["Priority"].value_counts())

print("\n")

print("=" * 60)

print("Top 10 Issue Categories")

print("=" * 60)

print(df["Issue_Category"].value_counts().head(10))

print("\n")

print("=" * 60)

print("Top 10 Cities")

print("=" * 60)

print(df["City"].value_counts().head(10))

print("\n")

print("=" * 60)

print("Sample Dataset")

print("=" * 60)

print(df.head())

print("\n")

print("=" * 60)

print("PROJECT COMPLETED SUCCESSFULLY")

print("=" * 60)
