import pandas as pd
import random

# ==========================================================
# LOAD ORIGINAL AGENT MASTER
# ==========================================================
df = pd.read_csv("../Data/agent_master.csv")

# ==========================================================
# INDIAN FIRST NAMES
# ==========================================================
first_names = [
    "Aarav","Vivaan","Aditya","Arjun","Krishna","Rohan","Rahul","Akash",
    "Karan","Siddharth","Mohit","Nitin","Aman","Harsh","Varun","Yash",
    "Abhishek","Ayush","Manish","Rakesh","Aniket","Saurabh","Vikas",
    "Deepak","Ritesh","Rohit","Ashish","Nikhil","Pranav","Tushar",
    "Ananya","Priya","Sneha","Neha","Pooja","Kavya","Aditi","Ritika",
    "Shreya","Meera","Nisha","Divya","Swati","Ishita","Riya","Simran",
    "Khushi","Tanvi","Muskan","Sakshi","Nandini","Shruti","Komal",
    "Payal","Aishwarya","Pallavi","Sonali","Preeti","Mansi"
]

# ==========================================================
# INDIAN LAST NAMES
# ==========================================================
last_names = [
    "Sharma","Patel","Rathod","Mehta","Shah","Joshi","Gupta","Singh",
    "Yadav","Verma","Reddy","Iyer","Nair","Kapoor","Desai","Kulkarni",
    "Pandey","Mishra","Chauhan","Das","Saxena","Agarwal","Bhat","Rao",
    "Malhotra","Trivedi","Bhatt","Parmar","Solanki","Jain","Thakur",
    "Soni","Kumar","Chawla","Gandhi","Naidu","Menon","Pillai","Shukla",
    "Dubey","Patil","Kale","Pawar"
]

# ==========================================================
# CREATE UNIQUE AGENT NAMES
# ==========================================================
agent_names = []

while len(agent_names) < len(df):

    name = f"{random.choice(first_names)} {random.choice(last_names)}"

    if name not in agent_names:
        agent_names.append(name)

# Replace original names
df["agent_name"] = agent_names

# ==========================================================
# SUPPORT TEAMS
# ==========================================================
teams = [
    "Technical Support",
    "Billing Support",
    "Order Management",
    "Returns & Refunds",
    "Account Support",
    "Product Support",
    "Delivery Support",
    "Payment Support",
    "Customer Success",
    "Premium Support"
]

# ==========================================================
# ONE MANAGER PER TEAM
# ==========================================================
manager_mapping = {
    "Technical Support": "Rahul Sharma",
    "Billing Support": "Neha Patel",
    "Order Management": "Amit Verma",
    "Returns & Refunds": "Priyanka Shah",
    "Account Support": "Rakesh Iyer",
    "Product Support": "Pooja Nair",
    "Delivery Support": "Vikram Desai",
    "Payment Support": "Anjali Mehta",
    "Customer Success": "Sandeep Gupta",
    "Premium Support": "Kavita Joshi"
}

# ==========================================================
# DISTRIBUTE AGENTS EQUALLY ACROSS TEAMS
# ==========================================================
assigned_teams = []

agents_per_team = len(df) // len(teams)

for team in teams:
    assigned_teams.extend([team] * agents_per_team)

remaining = len(df) - len(assigned_teams)

if remaining > 0:
    assigned_teams.extend(random.sample(teams, remaining))

random.shuffle(assigned_teams)

df["team"] = assigned_teams

# ==========================================================
# ASSIGN MANAGERS
# ==========================================================
df["manager"] = df["team"].map(manager_mapping)

# ==========================================================
# SAVE NEW MASTER FILE
# ==========================================================
df.to_csv("agent_master_indian.csv", index=False)

# ==========================================================
# SUMMARY
# ==========================================================
print("=" * 50)
print("INDIAN AGENT MASTER CREATED SUCCESSFULLY")
print("=" * 50)

print(f"Total Agents   : {len(df)}")
print(f"Total Teams    : {df['team'].nunique()}")
print(f"Total Managers : {df['manager'].nunique()}")

print("\nTeam Distribution")
print(df["team"].value_counts())

print("\nFirst 10 Records")
print(df.head(10))
