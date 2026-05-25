# Hostel-Management-System-Database
A relational database schema for a Hostel Management System designed in SQL Server, featuring multi-table relations, constraints, and custom analytic queries.
#  Hostel Management System - Relational Database Schema

##  Project Overview
This repository contains a complete relational database design for a **Hostel Management System** implemented in SQL. It structures backend records for an entire residential hostel infrastructure including students, room allocations, staff management, maintenance logging, and billing history.

##  Database Schema Architecture
The database consists of the following interconnected tables:
* **Students & Admins:** Managing user credentials and authentication profiles.
* **Rooms & Allocations:** Tracking room types (`Single`, `Double`, `Suite`), dynamic capacities, and current occupancy timelines.
* **Staff & Maintenance:** Log workflow automation for internal maintenance requests with progress state tracking (`Pending`, `InProgress`, `Completed`).
* **Financials & Security:** Standard bookkeeping for student fee installments and active visitor safety tracking logs.

##  Advanced Queries Implemented
The schema includes pre-compiled analysis queries for system operations:
1. Dynamic tracking of active room occupancies via relational `JOIN` statements.
2. Left-joined diagnostic query parsing maintenance tasks paired with active staff assignments.
3. Accounting query using `SUM` and `COUNT` summaries grouped by individual records.

##  Database Schema Architecture & ERD Structural Map

Below is the structural layout and Entity-Relationship (ER) mapping of the system, showcasing how primary keys (PK) and foreign keys (FK) connect across tables:

```text
[Students] (PK: student_id)
   │
   ├───◄ [Allocations] (FK: student_id) ►─── [Rooms] (PK: room_id)
   │                                             │
   ├───◄ [FeePayments] (FK: student_id)          │
   │                                             │
   ├───◄ [VisitorLogs] (FK: student_id)           │
   │                                             │
   └───◄ [MaintenanceRequests] (FK: student_id) ─┴─► (FK: room_id)
                                 │
                                 └───► [Staff] (PK: staff_id) (FK: staff_id)
