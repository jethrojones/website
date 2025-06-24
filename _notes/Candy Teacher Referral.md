
[[VAESP Presentation Resources]]

**Teacher Referral App Overview**

- Simple login for staff; admins see all, teachers see their own.
- Quick, easy referral submission: student name, incident, time, location, other students.
- Updates on referral status via app and email.
- Teachers track their own referrals; admins access full data.
- Secure and private.
- Admins generate referral data reports.

# Generated from ChatGPT


---

## 📱 **Teacher Referral App - Spec Sheet**

### 🔹 Overview

A lightweight web app to allow teachers to submit, track, and follow up on student behavior referrals. Admins have full visibility and can generate reports.

---

### 🔐 User Roles

#### 👩‍🏫 **Teacher**

- Can log in
    
- Submit new referrals
    
- View/edit their own referrals
    
- Receive updates via email/app
    

#### 🧑‍💼 **Admin**

- Can log in
    
- View all referrals
    
- Change referral status
    
- Generate and download referral reports
    

---

### ✅ Core Features

#### 1. **Authentication**

- Login via email/password (with option to add Google OAuth later)
    
- Role-based access control
    

#### 2. **Referral Submission**

- Fields:
    
    - Student Name (dropdown/searchable)
        
    - Date/Time of Incident (defaults to current)
        
    - Incident Description (text)
        
    - Location (dropdown)
        
    - Other Students Involved (optional)
        
- Submit button with validation
    

#### 3. **Referral Status Tracking**

- Status: New → In Review → Resolved/Returned
    
- Teachers see status updates in dashboard and via email
    
- Admins can update status and add notes
    

#### 4. **Dashboard**

- **Teachers**: List of their referrals, sortable by date/status
    
- **Admins**: List of all referrals with filters (date, student, teacher, status)
    

#### 5. **Notifications**

- Email alerts for status changes (use Replit + SMTP or 3rd party like SendGrid)
    
- In-app badges/alerts for new updates
    

#### 6. **Reports**

- Admin-only feature
    
- Export CSV reports filtered by:
    
    - Date range
        
    - Student
        
    - Referral status
        
    - Teacher
        

#### 7. **Security & Privacy**

- HTTPS enforcement
    
- Only authenticated users can access data
    
- Role-restricted access to data views
    
- Audit logs (optional stretch)
    


---

### 🗂 Folder Structure Example (Replit - Flask)

```
/referral-app
│
├── /templates/
│   └── dashboard.html, login.html, submit.html
├── /static/
│   └── styles.css, app.js
├── app.py
├── models.py
├── routes.py
├── auth.py
├── utils.py
├── database.db
└── README.md
```

---

### 🚧 MVP Scope

Only build:

- Login
    
- Referral submission form
    
- Basic dashboard for teachers
    
- Admin referral view
    
- Email updates (if time allows)
    

---

Would you like me to scaffold a `main.py` and HTML template starter for Replit next?